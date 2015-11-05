module LockerRoom
  module Testing
    module Controller
module AuthenticationHelpers
  include Warden::Test::Helpers

  private

    def login_user(user=nil)
      user ||= @user
      # see Testing::Controller::WardenHelpers
      warden.set_user(user, :scope => :user)
    end

    def logout_user
      warden.logout(:scope => :user)
    end
end
    end
  end
end
