require 'test_helper'

module LockerRoom
  class UserTest < ActiveSupport::TestCase
    locker_room_fixtures(:teams, :users, :mateships)

    def test_validation_with_too_long_name
      attributes = {
        :name => 'long' * 9
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'is too long (maximum is 32 characters)'
      assert_equal([message], user.errors[:name])
    end

    def test_validation_without_username
      attributes = {
        :username => nil
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'can\'t be blank'
      assert_equal([message], user.errors[:username])
    end

    def test_validation_with_too_short_username
      attributes = {
        :username => 'sh'
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'is too short (minimum is 3 characters)'
      assert_equal([message], user.errors[:username])
    end

    def test_validation_with_too_long_username
      attributes = {
        :username => 'yes' * 6
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'is too long (maximum is 16 characters)'
      assert_equal([message], user.errors[:username])
    end

    def test_validation_without_email
      attributes = {
        :email => nil
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'can\'t be blank'
      assert_equal([message], user.errors[:email])
    end

    def test_validation_with_duplicated_email
      user = user_with_schema(:oswald)
      team = user.teams.first
      attributes = {
        :email => user.email
      }
      user = team.mates.new(attributes)
      refute(user.valid?)
      message = 'has already been taken'
      assert_equal([message], user.errors[:email])
    end

    def test_validation_with_invalid_email
      attributes = {
        :email => 'invalid'
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'is invalid'
      assert_equal([message], user.errors[:email])
    end

    def test_validation_with_too_long_email
      attributes = {
        :email => 'long' * 30 + '@example.org'
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'is too long (maximum is 128 characters)'
      assert_equal([message], user.errors[:email])
    end

    def test_validation_without_current_password
      user = user_with_schema(:oswald)
      refute(user.valid?)
      message = 'can\'t be blank'
      assert_equal([message], user.errors[:current_password])
    end

    def test_validation_with_wrong_current_password
      user = user_with_schema(:oswald)
      user.current_password = 'penguin'
      refute(user.valid?)
      message = 'is not correct'
      assert_equal([message], user.errors[:current_password])
    end

    def test_validation_skip_current_password
      user = user_with_schema(:oswald)

      user.skip_password = true
      assert(user.valid?)
      assert_empty(user.errors[:current_password])

      user.current_password = false
      user.skip_current_password = true
      assert(user.valid?)
      assert_empty(user.errors[:current_password])
    end

    def test_validation_without_password
      attributes = {
        :password => nil
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'can\'t be blank'
      assert_equal([message], user.errors[:password])
    end

    def test_validation_with_too_short_password
      attributes = {
        :password => 'short'
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'is too short (minimum is 6 characters)'
      assert_equal([message], user.errors[:password])
    end

    def test_validation_with_mismatch_password_confirmation
      attributes = {
        :password              => 'secret',
        :password_confirmation => 'public'
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'doesn\'t match Password'
      assert_equal([message], user.errors[:password_confirmation])
    end

    def test_validation_without_password_confirmation
      attributes = {
        :password              => 'secret',
        :password_confirmation => nil
      }
      user = LockerRoom::User.new(attributes)
      refute(user.valid?)
      message = 'can\'t be blank'
      assert_equal([message], user.errors[:password_confirmation])
    end

    def test_creation
      team = team_with_schema(:playing_piano)
      attributes = {
        :username              => 'daisy',
        :name                  => 'Daisy',
        :email                 => 'daisy@example.org',
        :password              => 'hellyhollyhally',
        :password_confirmation => 'hellyhollyhally'
      }
      user = LockerRoom::User.new(attributes)
      assert(user.valid?)
      assert(user.save)
      assert(user.persisted?)
    end

    def test_creation_via_mateships
      team = team_with_schema(:playing_piano)
      attributes = {
        :username              => 'daisy',
        :name                  => 'Daisy',
        :email                 => 'daisy@example.org',
        :password              => 'hellyhollyhally',
        :password_confirmation => 'hellyhollyhally'
      }
      user = team.mates.create(attributes)
      assert_equal(team, user.teams.last)
      assert(user.persisted?)
      user.skip_current_password = true
      assert(user.valid?)
      team.mateships.reload
      assert_includes(team.mateships.pluck(:user_id), user.id)
    end

    def test_change_password_without_current_password
      user = user_with_schema(:oswald)
      assert(user.authenticate('secret'))
      attributes = {
        :password              => 'moresecret',
        :password_confirmation => 'moresecret'
      }
      refute(user.change_password!(attributes))
      message = 'is not correct'
      assert_equal({current_password: [message]}, user.errors.messages)
    end

    def test_change_password_with_wrong_password_confirmation
      user = user_with_schema(:oswald)
      assert(user.authenticate('secret'))
      attributes = {
        :current_password      => 'secret',
        :password              => 'moresecret',
        :password_confirmation => 'littlesecret'
      }
      refute(user.change_password!(attributes))
      message = 'doesn\'t match Password'
      assert_equal({password_confirmation: [message]}, user.errors.messages)
    end

    def test_change_password_update_password_digest
      user = user_with_schema(:oswald)
      assert(user.authenticate('secret'))

      old_digest = user.password_digest

      attributes = {
        :current_password      => 'secret',
        :password              => 'moresecret',
        :password_confirmation => 'moresecret'
      }
      assert(user.change_password!(attributes))
      new_digest = user.password_digest
      assert_not_equal(old_digest, new_digest)
    end
  end
end
