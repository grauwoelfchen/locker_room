require 'locker_room/testing_support/authentication_helpers'

module AuthenticationHelpers
  def self.included(klass)
    klass.class_eval do
      include LockerRoom::TestingSupport::AuthenticationHelpers
    end
  end
end
