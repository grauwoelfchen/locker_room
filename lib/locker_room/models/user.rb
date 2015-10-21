module LockerRoom
  module Models
    module User
      extend ActiveSupport::Concern

      included do
        extend ScopedTo

        has_secure_password

        has_many :mateships, class_name: 'LockerRoom::Mateship'
        has_many :ownerships,
          -> { where(:role => LockerRoom::Mateship.roles[:owner]) },
          class_name: 'LockerRoom::Mateship'
        has_many :memberships,
          -> { where(:role => LockerRoom::Mateship.roles[:member]) },
          class_name: 'LockerRoom::Mateship'
        has_many :teams,
          through: :mateships,
          source:  :team

        validates :username,
          presence:   true,
          uniqueness: true
        validates :username,
          length:      {minimum: 3, maximum: 16},
          allow_blank: true
        validates :name,
          length: {maximum: 32}
        validates :email,
          presence: true
        validates :email,
          uniqueness:  true,
          format:      {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},
          allow_blank: true
        validates :email,
          length:      {maximum: 128},
          allow_blank: true,
          if:          ->(u) { u.errors[:email].empty? }
        validates :password,
          presence: true,
          on:       :update,
          unless:   ->(u) { u.skip_password }
        validates :password,
          length:      {minimum: 6},
          allow_blank: true
        validates :password_confirmation,
          presence: true,
          if:       'password.present?'

        attr_accessor :skip_password
      end
    end
  end
end
