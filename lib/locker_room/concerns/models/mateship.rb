module LockerRoom
  module Concerns
    module Models
module Mateship
  extend ActiveSupport::Concern

  included do
    extend ScopedTo

    enum_accessor :role, [:owner, :mate]

    belongs_to :team, class_name: "LockerRoom::Team"
    belongs_to :user, class_name: "LockerRoom::User"

    validates :name,
      length: {maximum: 32}

    def nickname
      user.username
    end
  end
end
    end
  end
end
