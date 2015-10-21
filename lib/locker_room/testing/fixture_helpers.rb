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
          %w{team mateship user type}.map do |model|
            define_method("locker_room_#{model.pluralize}".intern) do |name|
              data_id = ActiveRecord::FixtureSet.identify(name)
              klass = Object.const_get("LockerRoom::#{model.classify}")
              klass.find(data_id)
            end
          end
        end

        private

          def team_with_schema(team_name)
            team = locker_room_teams(team_name)
            team.create_schema
            team
          end

          def user_with_schema(user_name)
            user = locker_room_users(user_name)
            user.teams.map(&:create_schema)
            user
          end
      end
    end
  end
end
