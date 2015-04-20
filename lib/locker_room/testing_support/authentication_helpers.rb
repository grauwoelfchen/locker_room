module LockerRoom
  module TestingSupport
    module AuthenticationHelpers
      # https://github.com/NoamB/sorcery/blob/master/lib/sorcery/test_helpers/rails/integration.rb
      include Sorcery::TestHelpers::Rails::Integration

      alias_method :orig_login_user, :login_user
      def login_user(user=nil, route=nil, http_method=:post)
        if user
          route ||= locker_room.login_url(:subdomain => user.account.subdomain)
        end
        orig_login_user(user, route, http_method)
      end

      alias_method :orig_logout_user, :logout_user
      def logout_user(*args)
        if args.length == 1 # set default http_method as :delete
          args[1] = :delete
        end
        orig_logout_user(*args)
      end
    end
  end
end
