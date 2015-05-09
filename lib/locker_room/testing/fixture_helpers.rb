module LockerRoom
  module Testing
    module FixtureHelpers
      def self.included(klass)
        klass.class_eval do
          def self.locker_room_fixtures(*fixture_names)
            fixtures(*fixture_names.map { |name| "locker_room/#{name}" })
          end
        end

        private

        def account_with_schema(account_name)
          account = locker_room_accounts(account_name)
          account.create_schema
          account
        end

        def user_with_schema(user_name)
          user = locker_room_users(user_name)
          user.account.create_schema
          user
        end
      end
    end
  end
end
