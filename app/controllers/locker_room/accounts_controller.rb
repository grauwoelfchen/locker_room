require_dependency "locker_room/application_controller"

module LockerRoom
  class AccountsController < ApplicationController
    def new
      @account = LockerRoom::Account.new
      @account.build_owner
    end

    def create
      @account = LockerRoom::Account.create(account_params)
      login(@account.owner.email, account_params[:owner_attributes][:password])
      flash[:success] = "Your account has been successfully created."
      redirect_to locker_room.root_url
    end

    private

      def account_params
        params.require(:account).permit(:name, :subdomain, {
          :owner_attributes => [
            :email, :password, :password_confirmation
          ]
        })
      end
  end
end
