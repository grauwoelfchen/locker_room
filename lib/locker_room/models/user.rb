require 'securerandom'

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
          if:       ->(u) {
            u.password.present? &&
            u.errors.messages[:password_confirmation].blank?
          }

        validate :check_current_password,
          if: ->(u) { u.current_password.present? && !u.skip_current_password }

        def self.load_from_reset_password_token(token)
          return nil if token.blank?
          user = find_by(:reset_password_token => token)
          return nil unless user
          exprs = user.reset_password_token_expires_at
          return nil if exprs.blank? || Time.now.in_time_zone >= exprs
          user
        end

        # https://github.com/rails/rails/blob/ \
        #   7f18ea14c893cb5c9f04d4fda9661126758332b5/activemodel/ \
        #   lib/active_model/secure_password.rb#L112
        def change_password!(password_attributes)
          unless skip_current_password
            self.current_password = password_attributes[:current_password]
            authenticated = validate_current_password
          else
            authenticated = true
          end
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

        def reset_password!
          generate_reset_password_token!
          send_reset_password_email!
        end

        %i[username email].each do |fld|
          define_method("validate_#{fld}_only") do |&block|
            self.class.validators_on(fld).each do |chk|
              # check additional condition
              next if block && !block.call(chk)
              # check options
              next if chk.options[:on] === :create && persisted? == true
              next if chk.options[:on] === :update && persisted? == false
              next if chk.options[:if] && !chk.options[:if].call(self)
              next if chk.options[:unless] && chk.options[:unless].call(self)
              val = self.send(fld)
              next if chk.options[:allow_blank] && val.blank?
              next if chk.options[:allow_nil] && val.nil?
              chk.validate_each(self, fld, val)
            end
            errors[fld].blank?
          end
        end

        def validate_email_except_uniqueness
          validate_email_only do |chk|
            chk.class != ActiveRecord::Validations::UniquenessValidator
          end
        end

        def validate_current_password
          check_current_password
          errors[:current_password].blank?
        end

        protected

        def generate_reset_password_token!
          token = SecureRandom.base64(16).tr('+/=1lIO0', 'pseNEioZ')
          exprs = Time.now.in_time_zone + 1.hours
          attrs = {
            :reset_password_token            => token,
            :reset_password_token_expires_at => exprs
          }
          self.skip_password = true
          update_attributes(attrs)
        end

        def send_reset_password_email!
          mailer = LockerRoom::CredentialMailer.reset_password_email(self)
          mailer.deliver_now
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
