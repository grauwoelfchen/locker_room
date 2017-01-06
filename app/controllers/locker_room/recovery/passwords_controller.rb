require_dependency 'locker_room/application_controller'

module LockerRoom
  module Recovery
    class PasswordsController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :set_user_from_token, only: [:edit, :update]

      def new
        @user = User.new
      end

      def create
        @user = User.new(:email => user_params[:email])
        if @user.validate_email_except_uniqueness
          @user = User.find_by_email(user_params[:email])
          if @user
            set_url_options_for_mailer
            @user.reset_password!
            flash[:notice] = 'Password reset instruction has been sent.'
          end
          redirect_to locker_room.login_url
        else
          render :new
        end
      end

      def edit
      end

      def update
        @user.skip_current_password = true
        if @user.change_password!(user_params)
          logout
          flash[:notice] = 'Password has been updated successfully.'
          redirect_to locker_room.login_url
        else
          flash.now[:alert] = 'Password could not be updated.'
          render :edit
        end
      end

      private

      def set_url_options_for_mailer
        ActionMailer::Base.default_url_options[:protocol] = request.protocol
        ActionMailer::Base.default_url_options[:host] = request.host_with_port
      end

      def set_user_from_token
        logout
        @user = User.load_from_reset_password_token(params[:token])
        unless @user
          flash[:alert] = 'Token is invalid.'
          not_authenticated
        end
      end

      def user_params
        params.require(:user).permit(
          :email, :password, :password_confirmation
        )
      end
    end
  end
end
