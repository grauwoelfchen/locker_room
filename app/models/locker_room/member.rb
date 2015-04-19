module LockerRoom
  class Member < ActiveRecord::Base
    enum_accessor :role, [:owner, :member]

    belongs_to :account, :class_name => "LockerRoom::Account"
    belongs_to :user,    :class_name => "LockerRoom::User"
  end
end
