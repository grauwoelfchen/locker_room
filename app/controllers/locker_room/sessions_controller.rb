require_dependency 'locker_room/application_controller'

module LockerRoom
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:new, :create]

    # Renders subdomain form
    def new
    end

    # Tries to switch team
    def create
      return render :new unless params[:subdomain].present?
      team = LockerRoom::Team.find_by(:subdomain => params[:subdomain])
      if team
        redirect_to locker_room.login_url(:subdomain => team.subdomain),
          :notice => 'Please signin.'
      else
        flash.now[:alert] = 'Team is not found.'
        render :new
      end
    end
  end
end
