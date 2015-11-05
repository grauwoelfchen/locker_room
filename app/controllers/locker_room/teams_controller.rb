require_dependency 'locker_room/application_controller'

module LockerRoom
  class TeamsController < ApplicationController
    skip_filter :authenticate_user!, only: [:new, :create]

    # Renders new team form
    def new
      @team = LockerRoom::Team.new
      @team.owners.build
    end

    # Creates a new team with its owner
    def create
      @team = LockerRoom::Team.create_with_owner(team_params)
      if @team.created?
        force_authentication!(@team.primary_owner)
        redirect_to locker_room.root_url(:subdomain => @team.subdomain),
          :notice => 'Team has been successfully created.'
      else
        flash[:alert] = 'Team could not be created.'
        render :new
      end
    end

    private

      def team_params
        params.require(:team).permit(
          :name, :subdomain, {
            :owners_attributes => [
              :username, :email, :name, :password, :password_confirmation
            ]
          }
        )
      end

      def owner_params
        owners_attributes = team_params[:owners_attributes]
        (owners_attributes && owners_attributes['0']) || {}
      end
  end
end
