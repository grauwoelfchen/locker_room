require_dependency "locker_room/application_controller"

module LockerRoom
  class LoginController < ApplicationController
    skip_filter :require_login, :only => [:new, :create]

    def new
    end

    def create
      return render :new unless params[:subdomain].present?
      account = LockerRoom::Account.find_by(:subdomain => params[:subdomain])
      if account
        redirect_to locker_room.root_url(:subdomain => account.subdomain)
      else
        flash[:alert] = "Account is not found."
        render :new
      end
    end
  end
end
