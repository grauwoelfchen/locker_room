require_dependency "locker_room/application_controller"

module LockerRoom
  class Account::SessionsController < ApplicationController
    skip_filter :require_login, :only => [:new, :create]

    def new
    end

    def create
      user = login(params[:email], params[:password])
      if user
        flash[:notice] = "You are now signed in."
        redirect_to locker_room.account_root_url
      else
        flash[:error] = "Email or password is invalid."
        render :new
      end
    end
  end
end
