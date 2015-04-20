require "locker_room/testing_support/integration/subdomain_helpers"

module Integration
  module SubdomainHelpers
    def self.included(klass)
      klass.class_eval do
        include LockerRoom::TestingSupport::Integration::SubdomainHelpers
      end
    end
  end
end
