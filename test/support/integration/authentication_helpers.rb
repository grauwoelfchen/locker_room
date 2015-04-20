require "locker_room/testing_support/integration/authentication_helpers"

module Integration
  module AuthenticationHelpers
    def self.included(klass)
      klass.class_eval do
        include LockerRoom::TestingSupport::Integration::AuthenticationHelpers
      end
    end
  end
end
