module LockerRoom
  module Testing
    module FixtureHelpers
      def self.included(klass)
        klass.class_eval do

          ##
          # This creates locker room fixtures immediately!
          #
          # @param fixture_set_names [Array] fixture set name in yml
          #
          def self.locker_room_fixtures(*fixture_set_names)
            # fixtures(*fixture_names.map { |name| "locker_room/#{name}" })
            # create immediately
            fixture_set_names.map do |name|
              ActiveRecord::FixtureSet
                .create_fixtures('test/fixtures', "locker_room/#{name}")
            end
          end

          # TODO: cache

          def locker_room_accounts(name)
            account_id = ActiveRecord::FixtureSet.identify(name)
            LockerRoom::Account.find(account_id)
          end

          def locker_room_members(name)
            member_id = ActiveRecord::FixtureSet.identify(name)
            LockerRoom::Member.find(member_id)
          end

          def locker_room_users(name)
            user_id = ActiveRecord::FixtureSet.identify(name)
            LockerRoom::User.find(user_id)
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
