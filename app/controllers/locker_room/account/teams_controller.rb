require_dependency "locker_room/application_controller"

module LockerRoom
  module Account
    class TeamsController < ApplicationController
      before_filter :authorize_owner, only: [:edit, :update, :plan]
      before_action :set_plan, only: [:plan, :subscribe, :confirm_plan]

      def edit
      end

      def update
        plan_id = team_params.delete(:plan_id)
        if current_team.update_attributes(team_params.except(:plan_id))
          flash[:notice] = 'Team has been updated successfully.'
          if plan_id != current_team.plan_id.to_s
            redirect_to locker_room.plan_team_url(:plan_id => plan_id)
          else
            redirect_to locker_room.root_path
          end
        else
          flash[:error] = 'Team could not be updated.'
          render :edit
        end
      end

      def plan
      end

      def subscribe
        @result = Braintree::TransparentRedirect.confirm(request.query_string)
        if @result.success?
          subscription_result = Braintree::Subscription.create(
            :payment_method_token => @result.customer.credit_cards[0].token,
            :plan_id              => @plan.braintree_id
          )
          subscription_id = subscription_result.subscription.id
          current_team.update_column(:plan_id, params[:plan_id])
          current_team.update_column(:subscription_id, subscription_id)
          flash[:notice] = "Your team is now on the '#{@plan.name}' plan."
          redirect_to locker_room.root_path
        else
          flash[:alert] = 'Invalid credit card details. Please try again.'
          render :plan
        end
      end

      def confirm_plan
        begin
          subscription_id = current_team.subscription_id
          subscription_result = Braintree::Subscription.update(
            subscription_id,
            :plan_id => @plan.braintree_id
          )
        rescue Braintree::NotFoundError
          subscription_result = nil
        end
        if subscription_result && subscription_result.success?
          current_team.update_column(:plan_id, @plan.id)
          flash[:notice] =
            "Your team has switched to the '#{@plan.name}' plan."
          redirect_to locker_room.root_path
        else
          flash[:error] = 'Something went wrong. Please try again.'
          render :plan
        end
      end

      private

        def set_plan
          @plan = LockerRoom::Plan.find(params[:plan_id])
        end

        def team_params
          params.require(:team).permit(:name, :plan_id)
        end
    end
  end
end
