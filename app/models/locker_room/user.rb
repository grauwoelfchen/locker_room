module LockerRoom
  class User < ActiveRecord::Base
    authenticates_with_sorcery!

    has_many :memberships, :class_name => "LockerRoom::Member"
    has_many :accounts, :through => :memberships

    validates :password, :confirmation => true, :presence => true
    validates :password_confirmation, :presence => true
  end
end
