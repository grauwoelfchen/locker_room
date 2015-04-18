module LockerRoom
  class Account < ActiveRecord::Base
    EXCLUDED_SUBDOMAINS = %w(admin test www new)

    belongs_to :owner, :class_name => "LockerRoom::User"
    accepts_nested_attributes_for :owner

    has_many :members, :class_name => "LockerRoom::Member"
    has_many :users, :through => :members

    validates :name,
      :presence => true
    validates :name,
      :length => {:maximum => 32}

    validates :subdomain,
      :presence => true, :uniqueness => true
    validates :subdomain,
      :length => {:maximum => 64}
    validates :subdomain,
      :length => {:minimum => 3},
      :if     => ->(a) { a.subdomain.present? }
    validates :subdomain,
      :exclusion => {in: EXCLUDED_SUBDOMAINS, :message => "is not allowed"}
    validates :subdomain,
      :format => {with: /\A[\w\-]+\Z/i, :message => "is not allowed"},
      :if     => ->(a) { a.subdomain.present? }

    before_validation do
      self.subdomain = subdomain.to_s.downcase
    end
  end
end
