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
      attributes = {
        :email   => user.email,
        :team => user.team
      }
      user = LockerRoom::User.new(attributes)
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
        :team_id               => team.id,
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
      assert_equal(team, user.team)
    end

    def test_creation_with_mateship
      team = team_with_schema(:playing_piano)
      attributes = {
        :team_id               => team.id,
        :username              => 'daisy',
        :name                  => 'Daisy',
        :email                 => 'daisy@example.org',
        :password              => 'hellyhollyhally',
        :password_confirmation => 'hellyhollyhally'
      }
      user = team.users.create_with_mateship(attributes)
      assert(user.mateship.persisted?)
      assert(user.persisted?)
      assert(user.created?)
      team.mateships.reload
      assert_includes(team.mateships.pluck(:user_id), user.id)
    end
  end
end
