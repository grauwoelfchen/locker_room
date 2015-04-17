module LockerRoom
  class Member < ActiveRecord::Base
    belongs_to :account, :class_name => "LockerRoom::Account"
    belongs_to :user,    :class_name => "LockerRoom::User"
  end
end
