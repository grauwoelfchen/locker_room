require_dependency "locker_room/application_controller"

module LockerRoom
  class AccountsController < ApplicationController
    def new
      @account = LockerRoom::Account.new
      @account.build_owner
    end

    def create
      @account = LockerRoom::Account.new(account_params)
      if @account.save
        login(@account.owner.email, owner_params[:password])
        flash[:notice] = "Your account has been successfully created."
        redirect_to locker_room.root_url(:subdomain => @account.subdomain)
      else
        flash[:error] = "Sorry, your account could not be created."
        render :new
      end
    end

    private

      def account_params
        params.require(:account).permit(:name, :subdomain, {
        :owner_attributes => [
          :email, :password, :password_confirmation
        ]})
      end

      def owner_params
        account_params[:owner_attributes] || {}
      end
  end
end
