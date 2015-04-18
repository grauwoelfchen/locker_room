require 'locker_room/testing_support/subdomain_helpers'

module SubdomainHelpers
  def self.included(klass)
    klass.class_eval do
      include LockerRoom::TestingSupport::SubdomainHelpers
    end
  end
end
