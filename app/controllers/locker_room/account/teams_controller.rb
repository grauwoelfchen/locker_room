require_dependency "locker_room/application_controller"

module LockerRoom
  module Account
    class TeamsController < ApplicationController
      before_filter :authorize_owner, only: [:edit, :update, :plan]

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
        @plan = LockerRoom::Plan.find(params[:plan_id])
      end

      def subscribe
        @plan = LockerRoom::Plan.find(params[:plan_id])
        result = Braintree::TransparentRedirect.confirm(request.query_string)
        if result.success?
          subscription_result = Braintree::Subscription.create(
            :payment_method_token => result.customer.credit_cards[0].token,
            :plan_id              => @plan.braintree_id
          )
          current_team.update_attributes(:plan_id => params[:plan_id])
          flash[:notice] = "Your team is now on the '#{@plan.name}' plan."
          redirect_to locker_room.root_path
        end
      end

      private

        def team_params
          params.require(:team).permit(:name, :plan_id)
        end
    end
  end
end
