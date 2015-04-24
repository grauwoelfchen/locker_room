require "sorcery/test_helpers/rails/integration"

module LockerRoom
  module TestingSupport
    module Integration
module AuthenticationHelpers
  include Sorcery::TestHelpers::Rails::Integration

  def self.included(klass)
    klass.class_eval do
      if defined?(LockerRoom::TestingSupport::Secret::Helpers)
        def login_as(user, route=nil, http_method=:post)
          if user
            route ||= locker_room.login_url(
              :subdomain => user.account.subdomain)
          end

          password = LockerRoom::TestingSupport::Secret::Helpers
            .password_of(user)
          login_user_with_password(user, route, http_method, password)
        end
      end
    end
  end

  alias_method :orig_login_user, :login_user
  def login_user(user=nil, route=nil, http_method=:post)
    # subdomain route support
    if user
      route ||= locker_room.login_url(:subdomain => user.account.subdomain)
    end

    orig_login_user(user, route, http_method)
  end

  def login_user_with_password(user=nil, route=nil, http_method=nil,
                               password=nil)
    # subdomain route support
    if user
      route ||= locker_room.login_url(:subdomain => user.account.subdomain)
    end

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
