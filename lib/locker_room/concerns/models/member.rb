module LockerRoom
  module Concerns
    module Models
module Member
  extend ActiveSupport::Concern

  included do
    extend ScopedTo

    enum_accessor :role, [:owner, :member]

    belongs_to :account, :class_name => "LockerRoom::Account"
    belongs_to :user,    :class_name => "LockerRoom::User"
  end
end
    end
  end
end
