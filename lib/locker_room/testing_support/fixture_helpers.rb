module LockerRoom
  module TestingSupport
    module FixtureHelpers
      def self.included(klass)
        klass.class_eval do
          def self.locker_room_fixtures(*fixture_names)
            fixtures(*fixture_names.map { |name| "locker_room/#{name}" })
          end
        end
      end
    end
  end
end
