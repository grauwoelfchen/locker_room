require_dependency 'locker_room/application_controller'

module LockerRoom
  module Account
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:new, :create]

      # Renders user signin form
      def new
      end

      # Tries to login user
      def create
        user = login_with_subdomain(params[:email], params[:password])
        if user
          flash[:notice] = 'You are now signed in.'
          redirect_to locker_room.root_url
        else
          flash.now[:alert] = 'Email or password is invalid.'
          render :new
        end
      end

      # Logout user
      def destroy
        logout
        redirect_to locker_room.login_url(:subdomain => current_subdomain),
          :notice => 'Logged out.'
      end
    end
  end
end
