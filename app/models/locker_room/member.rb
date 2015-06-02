module LockerRoom
  class Member < ActiveRecord::Base
    include Concerns::Models::Member
  end
end
