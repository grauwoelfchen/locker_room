require 'test_helper'

module LockerRoom
  class MembershipTest < ActiveSupport::TestCase
    locker_room_fixtures(:teams, :users, :memberships)

    def test_validation_with_too_long_username
      attributes = {
        :name => "hellyhollyhally" * 3
      }
      membership = LockerRoom::Membership.new(attributes)
      refute(membership.valid?)
      message = "is too long (maximum is 32 characters)"
      assert_equal([message], membership.errors[:name])
    end
  end
end
