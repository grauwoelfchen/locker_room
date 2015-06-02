module LockerRoom
  class Account < ActiveRecord::Base
    EXCLUDED_SUBDOMAINS = %w(admin test www new)

    has_many :users,   class_name: "LockerRoom::User"
    has_many :members, class_name: "LockerRoom::Member"
    has_many :ownerships,
      -> { where(:role => LockerRoom::Member.roles[:owner]) },
      class_name: "LockerRoom::Member"
    has_many :owners,
      through: :ownerships,
      source:  :user
    accepts_nested_attributes_for :owners

    validates :name,
      presence: true
    validates :name,
      length:      {maximum: 32},
      allow_blank: true
    validates :subdomain,
      presence: true
    validates :subdomain,
      length:      {minimum: 3, maximum: 64},
      uniqueness:  true,
      allow_blank: true
    validates :subdomain,
      exclusion:   {in: EXCLUDED_SUBDOMAINS,
                     message: "%{value} is not allowed"},
      format:      {with: /\A[\w\-]+\Z/i,
                    message: "%{value} is not allowed"},
      allow_blank: true

    before_validation do
      self.subdomain = subdomain.to_s.downcase
    end

    def self.create_with_owner(options={})
      self.transaction do
        account = new(options)
        if account.save
          owner = account.owners.first
          unless owner && owner.update_attribute(:account, account)
            raise ActiveRecord::Rollback
          end
        end
        account
      end
    end

    def created?
      persisted? && (owner = owners.first) && owner.persisted?
    end

    def create_schema
      Apartment::Tenant.create(schema_name)
    end

    def schema_name
      subdomain.gsub(/\-/, "_")
    end
  end
end
