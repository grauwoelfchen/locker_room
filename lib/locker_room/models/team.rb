module LockerRoom
  module Models
    module Team
      extend ActiveSupport::Concern

      included do
        EXCLUDED_SUBDOMAINS ||= %w(admin test www new)

        belongs_to :type, class_name: 'LockerRoom::Type'
        has_many :mateships, class_name: 'LockerRoom::Mateship'
        has_many :mates,
          through: :mateships,
          source:  :user
        has_many :ownerships,
          -> { where_role(:owner) },
          class_name: 'LockerRoom::Mateship'
        has_many :owners,
          through: :ownerships,
          source:  :user
        has_many :memberships,
          -> { where_role(:member) },
          class_name: 'LockerRoom::Mateship'
        has_many :members,
          through: :memberships,
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
                        message: '%{value} is not allowed'},
          format:      {with: /\A[\w\-]+\Z/i,
                        message: '%{value} is not allowed'},
          allow_blank: true

        before_validation do
          self.subdomain = subdomain.to_s.downcase
        end

        def primary_owner
          owners.order(:id => :asc).first
        end

        def owner?(user)
          owners.pluck(:id).include?(user.id)
        end

        def created?
          persisted? && (owner = primary_owner) && owner.persisted?
        end

        def create_schema
          Apartment::Tenant.create(schema_name)
        end

        def schema_name
          subdomain.gsub(/\-/, '_')
        end
      end

      class_methods do
        def create_with_owner(options={})
          self.transaction do
            team = new(options)
            if team.save
              raise ActiveRecord::Rollback unless team.primary_owner
              team.create_schema
            end
            team
          end
        end
      end
    end
  end
end
