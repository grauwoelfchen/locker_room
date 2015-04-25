module LockerRoom
  module Testing
    module Integration
module AuthenticationHelpers
  include Sorcery::TestHelpers::Rails::Integration

  alias_method :orig_login_user, :login_user
  def login_user(user=nil, route=nil, http_method=:post)
    # subdomain route support
    if user && !route
      route = locker_room.login_url(:subdomain => user.account.subdomain)
    end
    orig_login_user(user, route, http_method)
  end
end
    end
  end
end
