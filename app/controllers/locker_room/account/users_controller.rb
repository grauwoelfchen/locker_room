require_dependency 'locker_room/application_controller'

module LockerRoom
  module Account
    class UsersController < ApplicationController
      skip_before_action :authenticate_user!, only: [:new, :create]

      def new
        @user = LockerRoom::User.new
      end

      def create
        raise ActiveRecord::RecordNotFound unless current_team

        @user = current_team.mates.create(user_params)
        @user.skip_current_password = true
        if @user.valid?
          force_authentication!(@user)
          flash[:notice] = 'You have signed up successfully.'
          redirect_to locker_room.root_url
        else
          flash.now[:alert] = 'Your user account could not be created.'
          render :new
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :username, :name, :email, :password, :password_confirmation
        )
      end
    end
  end
end
