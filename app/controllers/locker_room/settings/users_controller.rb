require_dependency "locker_room/application_controller"

module LockerRoom
  module Settings
    class UsersController < ApplicationController
      before_action :set_user

      def edit
      end

      def update
        @user.skip_password = true unless user_params[:password].present?
        if @user.update_attributes(user_params)
          flash[:notice] = 'Account has been updated successfully.'
          redirect_to locker_room.root_path
        else
          flash[:error] = 'Account could not be updated.'
          render :edit
        end
      end

      private

      def set_user
        @user = current_user
      end

      def user_params
        params.require(:user).permit(
          :username, :name, :email,
          # optional
          :password, :password_confirmation
        )
      end
    end
  end
end
