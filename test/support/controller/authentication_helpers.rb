require "locker_room/testing_support/controller/authentication_helpers"

module Controller
  module AuthenticationHelpers
    def self.included(klass)
      klass.class_eval do
        include Sorcery::TestHelpers::Rails::Controller
      end
    end
  end
end
