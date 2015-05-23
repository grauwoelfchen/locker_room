module LockerRoom
  module Concerns
    module Models
module User
  extend ActiveSupport::Concern

  included do
    extend ScopedTo

    authenticates_with_sorcery!

    belongs_to :account
    has_one :member, class_name: "LockerRoom::Member"
    accepts_nested_attributes_for :member

    validates :email,
      presence: true
    validates :email,
      uniqueness: {scope: [:account_id]},
      if:         ->(u) { u.email.present? }
    validates :email,
      format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},
      if:     ->(u) { u.email.present? }
    validates :email,
      length: {maximum: 128},
      if:     ->(u) { u.email.present? && u.errors[:email].empty? }

    validates :password,
      presence: true,
      unless:   ->(u) { u.skip_password }
    validates :password,
      length: {minimum: 6},
      if:     ->(u) { u.password.present? }
    validates :password,
      confirmation: true,
      if:           ->(u) { u.password.present? }
    validates :password_confirmation,
      presence: true,
      if:       ->(u) { u.password.present? }

    attr_accessor :skip_password
  end

  class_methods do
    def create_with_member(options={})
      self.transaction do
        user = self.new(options)
        if user.save
          member = user.build_member
          member.assign_attributes(:account_id => user.account_id)
          unless member.save
            raise ActiveRecord::Rollback
          end
        end
        user
      end
    end
  end

  def created?
    persisted? && member && member.persisted?
  end
end
    end
  end
end
