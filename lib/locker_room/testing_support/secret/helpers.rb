require "locker_room/testing_support/secret/utilities"

module LockerRoom
  module TestingSupport
    module Secret
module Helpers
  extend Utilities

  def self.password_of(user)
    secret_value[user.id]["password"]
  rescue NoMethodError
    raise Secret::FixtureNotFound
  end

  def self.secret_value
    secret_hash.map { |key, value|
      [ActiveRecord::FixtureSet.identify(key.intern), value]
    }.to_h
  end
end
    end
  end
end
