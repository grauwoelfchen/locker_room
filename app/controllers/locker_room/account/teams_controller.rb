require_dependency "locker_room/application_controller"

module LockerRoom
  module Account
    class TeamsController < ApplicationController
      before_filter :authorize_owner, only: [:edit, :update]

      def edit
      end

      def update
        if current_team.update_attributes(team_params)
          flash[:notice] = 'Team has been updated successfully.'
          redirect_to locker_room.root_path
        else
          flash[:error] = 'Team could not be updated.'
          render :edit
        end
      end

      private

        def team_params
          params.require(:team).permit(:name)
        end
    end
  end
end
