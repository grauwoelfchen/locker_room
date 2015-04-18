module LockerRoom
  class User < ActiveRecord::Base
    authenticates_with_sorcery!

    has_many :memberships, :class_name => "LockerRoom::Member"
    has_many :accounts, :through => :memberships

    validates :password,
      :presence => true,
      :unless   => ->(u) { u.skip_password }
    validates :password,
      :confirmation => true,
      :if           => ->(u) { u.password.present? }

    attr_accessor :skip_password

    alias_method :orig_valid?, :valid?
    def valid?(context = nil, without_password: false)
      self.skip_password = without_password
      orig_valid?(context)
    end
  end
end
