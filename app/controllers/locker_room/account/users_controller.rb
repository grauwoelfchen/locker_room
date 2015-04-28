require_dependency "locker_room/application_controller"

module LockerRoom
  class Account::UsersController < ApplicationController
    skip_filter :require_login, :only => [:new, :create]

    def new
      @user = LockerRoom::User.new
      @user.build_member
    end

    def create
      raise ActiveRecord::RecordNotFound unless current_account

      @user = current_account.users.new(user_params)
      @user.member.assign_attributes(:account_id => current_account.id)
      if @user.save && @user.member.valid?
        login(@user.email, user_params[:password])
        flash[:notice] = "You have signed up successfully."
        redirect_to locker_room.root_url
      else
        flash[:alert] = "Your user account could not be created."
        render :new
      end
    end

    private

      def user_params
        params.require(:user).permit(
          :email, :password, :password_confirmation, {
            :member_attributes => [
              :name, :username
            ]
          }
        )
      end
  end
end
