require_dependency "locker_room/application_controller"

module LockerRoom
  class SessionsController < ApplicationController
    skip_filter :require_login, :only => [:new, :create]

    def new
    end

    def create
      return render :new unless params[:subdomain].present?
      team = LockerRoom::Team.find_by(:subdomain => params[:subdomain])
      if team
        redirect_to locker_room.root_url(:subdomain => team.subdomain)
      else
        flash[:alert] = "Team is not found."
        render :new
      end
    end
  end
end
