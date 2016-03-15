require_dependency 'locker_room/application_controller'

module LockerRoom
  module Settings
    class TeamsController < ApplicationController
      before_filter :authorize_owner, only: [:edit, :update, :type]
      before_action :set_type, only: [:type, :subscribe, :exchange]
      before_action :set_team

      def edit
      end

      def update
        type_id = team_params.delete(:type_id)
        if @team.update_attributes(team_params.except(:type_id))
          if type_id != current_team.type_id.to_s
            redirect_to locker_room.team_type_settings_url(:type_id => type_id)
          else
            flash[:notice] = 'Team has been updated successfully.'
            redirect_to locker_room.team_settings_url
          end
        else
          flash.now[:alert] = 'Team could not be updated.'
          render :edit
        end
      end

      # GET
      def type
      end

      # Tries to subscribe a new plan
      # POST
      def subscribe
        @result = Braintree::TransparentRedirect.confirm(request.query_string)
        if @result.success?
          subscription_result = Braintree::Subscription.create(
            :payment_method_token => @result.customer.credit_cards[0].token,
            :plan_id              => @type.plan_id
          )
          subscription_id = subscription_result.subscription.id
          @team.update_column(:type_id, params[:type_id])
          @team.update_column(:subscription_id, subscription_id)
          flash[:notice] = "Your team is now on the '#{@type.name}' type."
          redirect_to locker_room.team_settings_url
        else
          flash.now[:alert] = 'Invalid credit card details. Please try again.'
          render :type
        end
      end

      # Changes to another plan with same subscription
      # PUT, PATCH
      def exchange
        begin
          subscription_result = Braintree::Subscription.update(
            @team.subscription_id,
            :plan_id => @type.plan_id
          )
        rescue Braintree::NotFoundError
          subscription_result = nil
        end
        if subscription_result && subscription_result.success?
          @team.update_column(:type_id, @type.id)
          flash[:notice] =
            "Your team has switched to the '#{@type.name}' type."
          redirect_to locker_room.team_settings_url
        else
          flash.now[:alert] = 'Something went wrong. Please try again.'
          render :type
        end
      end

      private

      def set_type
        @type = LockerRoom::Type.find(params[:type_id])
      end

      def set_team
        @team = current_team
      end

      def team_params
        params.require(:team).permit(:name, :type_id)
      end
    end
  end
end
