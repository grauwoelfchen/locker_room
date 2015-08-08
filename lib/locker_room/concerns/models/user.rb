module LockerRoom
  module Concerns
    module Models
module User
  extend ActiveSupport::Concern

  included do
    extend ScopedTo

    authenticates_with_sorcery!

    belongs_to :team
    has_one :mateship, class_name: "LockerRoom::Mateship"
    accepts_nested_attributes_for :mateship

    validates :username,
      presence: true
    validates :username,
      length:      {minimum: 3, maximum: 16},
      allow_blank: true
    validates :email,
      presence: true
    validates :email,
      uniqueness:  {scope: [:team_id]},
      format:      {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},
      allow_blank: true
    validates :email,
      length:      {maximum: 128},
      allow_blank: true,
      if:          ->(u) { u.errors[:email].empty? }
    validates :password,
      presence: true,
      unless:   ->(u) { u.skip_password }
    validates :password,
      length:       {minimum: 6},
      confirmation: true,
      allow_blank:  true
    validates :password_confirmation,
      presence: true,
      if:       "password.present?"

    attr_accessor :skip_password
  end

  class_methods do
    def create_with_mateship(options={})
      self.transaction do
        user = self.new(options)
        if user.save
          mateship = user.build_mateship
          mateship.assign_attributes(:team_id => user.team_id)
          unless mateship.save
            raise ActiveRecord::Rollback
          end
        end
        user
      end
    end
  end

  def created?
    persisted? && mateship && mateship.persisted?
  end
end
    end
  end
end
