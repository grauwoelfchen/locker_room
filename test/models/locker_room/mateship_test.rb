require 'test_helper'

module LockerRoom
  class MateshipTest < ActiveSupport::TestCase
    locker_room_fixtures(:teams, :users, :mateships)

    def test_validation_with_too_long_username
      attributes = {
        :name => "hellyhollyhally" * 3
      }
      mateship = LockerRoom::Mateship.new(attributes)
      refute(mateship.valid?)
      message = "is too long (maximum is 32 characters)"
      assert_equal([message], mateship.errors[:name])
    end
  end
end
