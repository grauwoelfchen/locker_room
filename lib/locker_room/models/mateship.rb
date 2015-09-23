module LockerRoom
  module Models
    module Mateship
      extend ActiveSupport::Concern

      included do
        extend ScopedTo

        enum_accessor :role, [:owner, :mate]

        belongs_to :team, class_name: 'LockerRoom::Team'
        belongs_to :user, class_name: 'LockerRoom::User'
      end
    end
  end
end
