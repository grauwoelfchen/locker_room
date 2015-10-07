module LockerRoom
  module Testing
    module Controller
module AuthenticationHelpers
  include Warden::Test::Helpers

  private

  def login_user(user=nil)
    user ||= @user
    login_as(user, :scope => :user)
  end

  def logout_user
    logout(:user)
  end
end
    end
  end
end
