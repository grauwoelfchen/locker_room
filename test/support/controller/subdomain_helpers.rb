require "locker_room/testing_support/controller/subdomain_helpers"

module Controller
  module SubdomainHelpers
    def self.included(klass)
      klass.class_eval do
        include LockerRoom::TestingSupport::Controller::SubdomainHelpers
      end
    end
  end
end
