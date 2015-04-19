module LockerRoom
  class User < ActiveRecord::Base
    authenticates_with_sorcery!

    belongs_to :account
    has_one :member, :class_name => "LockerRoom::Member"
    accepts_nested_attributes_for :member

    validates :email,
      :uniqueness => {scope: [:account_id]}
    validates :password,
      :presence => true,
      :unless   => ->(u) { u.skip_password }
    validates :password,
      :confirmation => true,
      :if           => ->(u) { u.password.present? }

    attr_accessor :skip_password

    def self.save_as_member(options={})
      @user = @account.users.new(options)
      result = @user.save
      if result
        @user.build_member.save
      end
      result
    end

    alias_method :orig_valid?, :valid?
    def valid?(context = nil, without_password: false)
      self.skip_password = without_password
      orig_valid?(context)
    end
  end
end
