require_dependency "locker_room/application_controller"

module LockerRoom
  class AccountsController < ApplicationController
    skip_filter :require_login, :only => [:new, :create]

    def new
      @account = LockerRoom::Account.new
      @account.owners.build
    end

    def create
      @account = LockerRoom::Account.create_with_owner(account_params)
      if @account.valid? && owner = @account.owners.first
        login(owner.email, owner_params[:password])
        flash[:notice] = "Your account has been successfully created."
        redirect_to locker_room.root_url(:subdomain => @account.subdomain)
      else
        flash[:alert] = "Your account could not be created."
        render :new
      end
    end

    private

      def account_params
        params.require(:account).permit(
          :name, :subdomain, {
            :owners_attributes => [
              :email, :password, :password_confirmation
            ]
          }
        )
      end

      def owner_params
        owners_attributes = account_params[:owners_attributes]
        (owners_attributes && owners_attributes["0"]) || {}
      end
  end
end
