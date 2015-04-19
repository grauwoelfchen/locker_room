require_dependency "locker_room/application_controller"

module LockerRoom
  class Account::UsersController < ApplicationController
    skip_filter :require_login, :only => [:new, :create]

    def new
      @user = LockerRoom::User.new
      @user.build_member
    end

    def create
      load_account

      @user = @account.users.new(user_params)
      @user.member.assign_attributes(:account => @current_account)
      if @user.save && @user.member.valid?
        login(@user.email, user_params[:password])
        flash[:notice] = "You have signed up successfully."
        redirect_to locker_room.account_root_url
      else
        flash[:alert] = "Sorry, your user account could not be created."
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

      def load_account
        @account = current_account
        raise ActiveRecord::RecordNotFound unless @account
      end
  end
end
