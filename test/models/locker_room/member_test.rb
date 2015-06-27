require 'test_helper'

module LockerRoom
  class MemberTest < ActiveSupport::TestCase
    locker_room_fixtures(:accounts, :members, :users)

    def test_validation_with_too_long_username
      attributes = {
        :name => "hellyhollyhally" * 3
      }
      member = LockerRoom::Member.new(attributes)
      refute(member.valid?)
      message = "is too long (maximum is 32 characters)"
      assert_equal([message], member.errors[:name])
    end
  end
end
