module LockerRoom
  module Models
    module User
      extend ActiveSupport::Concern

      included do
        extend ScopedTo

        attr_accessor :current_password,
          :skip_password, :skip_current_password

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
          if:          ->(u) { u.errors.messages[:email].blank? }
        validates :current_password,
          presence: true,
          on:       :update,
          unless:   ->(u) { u.skip_password || u.skip_current_password }
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

        validate :check_current_password,
          if: ->(u) { u.current_password.present? && !u.skip_current_password }

        # https://github.com/rails/rails/blob/ \
        #   7f18ea14c893cb5c9f04d4fda9661126758332b5/activemodel/ \
        #   lib/active_model/secure_password.rb#L112
        def change_password!(password_attributes)
          self.current_password = password_attributes[:current_password]
          authenticated = validate_current_password
          self.skip_current_password = true
          assign_attributes(password_attributes)
          validated = authenticated && valid?
          self.skip_current_password = nil
          if validated
            update_attribute(:password, password_attributes[:password])
          else
            false
          end
        end

        def validate_current_password
          check_current_password
          errors[:current_password].blank?
        end

        private

        def check_current_password
          errors.add(:current_password, 'is not correct') \
            unless authenticate(current_password)
        end
      end
    end
  end
end
