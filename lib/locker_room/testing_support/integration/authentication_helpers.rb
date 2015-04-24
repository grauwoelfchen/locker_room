require "sorcery/test_helpers/rails/integration"
require "locker_room/testing_support/secret/helpers"

module LockerRoom
  module TestingSupport
    module Integration
module AuthenticationHelpers
  include Sorcery::TestHelpers::Rails::Integration

  alias_method :orig_login_user, :login_user
  def login_user(user=nil, route=nil, http_method=:post)
    # subdomain route support
    if user
      route ||= locker_room.login_url(:subdomain => user.account.subdomain)
    end

    orig_login_user(user, route, http_method)
  end

  def login_as(user, route=nil, http_method=:post)
    if user
      route ||= locker_room.login_url(:subdomain => user.account.subdomain)
    end

    password = LockerRoom::TestingSupport::Secret::Helpers.password_of(user)
    login_user_with_password(user, route, http_method, password)
  end

  def login_user_with_password(user=nil, route=nil, http_method=nil,
                               password=nil)
    user ||= @user
    route ||= sessions_url
    username_attr = user.sorcery_config.username_attribute_names.first
    username = user.send(username_attr)
    # use specified password instead of fixed 'secret'
    options = {:"#{username_attr}" => username, :password => password}
    page.driver.send(http_method, route, options)
  end
end
    end
  end
end
