require_dependency 'locker_room/application_controller'

module LockerRoom
  class TeamsController < ApplicationController
    skip_filter :require_login, :only => [:new, :create]

    def new
      @team = LockerRoom::Team.new
      @team.owners.build
    end

    def create
      @team = LockerRoom::Team.create_with_owner(team_params)
      if @team.created?
        login(@team.primary_owner.email, owner_params[:password])
        flash[:notice] = 'Team has been successfully created.'
        redirect_to locker_room.root_url(:subdomain => @team.subdomain)
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
              :username, :email, :password, :password_confirmation
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
