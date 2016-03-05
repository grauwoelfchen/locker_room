require_dependency "locker_room/application_controller"

module LockerRoom
  module Settings
    class PasswordsController < ApplicationController
      before_action :set_user

      def edit
      end

      def update
        if @user.change_password!(user_params)
          flash[:notice] = 'Password has been updated successfully.'
          redirect_to locker_room.edit_password_path
        else
          flash.now[:alert] = 'Password could not be updated.'
          render :edit
        end
      end

      private

      def set_user
        @user = current_user
      end

      def user_params
        params.require(:user).permit(
          :current_password, :password, :password_confirmation
        )
      end
    end
  end
end
