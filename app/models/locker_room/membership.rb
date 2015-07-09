module LockerRoom
  class Membership < ActiveRecord::Base
    include Concerns::Models::Membership
  end
end
