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
      length: {maximum: 32}
    validates :subdomain,
      presence: true, uniqueness: true
    validates :subdomain,
      length: {maximum: 64}
    validates :subdomain,
      length: {minimum: 3},
      if:     ->(a) { a.subdomain.present? }
    validates :subdomain,
      exclusion: {in: EXCLUDED_SUBDOMAINS, message: "%{value} is not allowed"}
    validates :subdomain,
      format: {with: /\A[\w\-]+\Z/i, message: "%{value} is not allowed"},
      if:     ->(a) { a.subdomain.present? }

    before_validation do
      self.subdomain = subdomain.to_s.downcase
    end

    def self.create_with_owner(options={})
      self.transaction do
        account = new(options)
        if account.save
          unless account.owners.first.update_attribute(:account, account)
            raise ActiveRecord::Rollback
          end
        end
        account
      end
    end
  end
end
