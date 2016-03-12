require 'test_helper'

module LockerRoom
  class UserTest < ActiveSupport::TestCase
    locker_room_fixtures(:teams, :users, :mateships)

    def test_validation_with_too_long_name
      user = LockerRoom::User.new(
        :name => 'long' * 9
      )
      refute(user.valid?)
      assert_equal(
        ['is too long (maximum is 32 characters)'],
        user.errors[:name]
      )
    end

    def test_validation_without_username
      user = LockerRoom::User.new(
        :username => nil
      )
      refute(user.valid?)
      assert_equal(
        ['can\'t be blank'],
        user.errors[:username]
      )
    end

    def test_validation_with_too_short_username
      user = LockerRoom::User.new(
        :username => 'sh'
      )
      refute(user.valid?)
      assert_equal(
        ['is too short (minimum is 3 characters)'],
        user.errors[:username]
      )
    end

    def test_validation_with_too_long_username
      user = LockerRoom::User.new(
        :username => 'yes' * 6
      )
      refute(user.valid?)
      assert_equal(
        ['is too long (maximum is 16 characters)'],
        user.errors[:username]
      )
    end

    def test_validation_without_email
      user = LockerRoom::User.new(
        :email => nil
      )
      refute(user.valid?)
      assert_equal(
        ['can\'t be blank'],
        user.errors[:email]
      )
    end

    def test_validation_with_duplicated_email
      user = user_with_schema(:oswald)
      mate = user.teams.first.mates.new(
        :email => user.email
      )
      refute(mate.valid?)
      assert_equal(
        ['has already been taken'],
        mate.errors[:email]
      )
    end

    def test_validation_with_invalid_email
      user = LockerRoom::User.new(
        :email => 'invalid'
      )
      refute(user.valid?)
      assert_equal(
        ['is invalid'],
        user.errors[:email]
      )
    end

    def test_validation_with_too_long_email
      user = LockerRoom::User.new(
        :email => 'long' * 30 + '@example.org'
      )
      refute(user.valid?)
      assert_equal(
        ['is too long (maximum is 128 characters)'],
        user.errors[:email]
      )
    end

    def test_validation_without_current_password
      user = user_with_schema(:oswald)
      refute(user.valid?)
      assert_equal(
        ['can\'t be blank'],
        user.errors[:current_password]
      )
    end

    def test_validation_with_wrong_current_password
      user = user_with_schema(:oswald)
      user.current_password = 'iampenguin'
      refute(user.valid?)
      assert_equal(
        ['is not correct'],
        user.errors[:current_password]
      )
    end

    def test_validation_skip_password
      user = user_with_schema(:oswald)
      user.skip_password = true
      assert(user.valid?)
      assert_empty(user.errors[:password])
      assert_empty(user.errors[:password_confirmation])
      assert_empty(user.errors[:current_password])
    end

    def test_validation_skip_current_password
      user = user_with_schema(:oswald)
      user.skip_current_password = true
      refute(user.valid?)
      refute_nil(user.errors[:password])
      assert_empty(user.errors[:password_confirmation])
      assert_empty(user.errors[:current_password])
    end

    def test_validation_without_password
      user = LockerRoom::User.new(
        :password => nil
      )
      refute(user.valid?)
      assert_equal(
        ['can\'t be blank'],
        user.errors[:password]
      )
    end

    def test_validation_with_too_short_password
      user = LockerRoom::User.new(
        :password => 'short'
      )
      refute(user.valid?)
      assert_equal(
        ['is too short (minimum is 6 characters)'],
        user.errors[:password]
      )
    end

    def test_validation_with_mismatch_password_confirmation
      user = LockerRoom::User.new(
        :password              => 'secret',
        :password_confirmation => 'public'
      )
      refute(user.valid?)
      assert_equal(
        ['doesn\'t match Password'],
        user.errors[:password_confirmation]
      )
    end

    def test_validation_without_password_confirmation
      user = LockerRoom::User.new(
        :password              => 'secret',
        :password_confirmation => nil
      )
      refute(user.valid?)
      assert_equal(
        ['can\'t be blank'],
        user.errors[:password_confirmation]
      )
    end

    def test_creation
      user = LockerRoom::User.new(
        :username              => 'daisy',
        :name                  => 'Daisy',
        :email                 => 'daisy@example.org',
        :password              => 'hellyhollyhally',
        :password_confirmation => 'hellyhollyhally'
      )
      assert(user.save)
      assert(user.persisted?)
    end

    def test_creation_via_mateships
      team = team_with_schema(:playing_piano)
      user = team.mates.create(
        :username              => 'daisy',
        :name                  => 'Daisy',
        :email                 => 'daisy@example.org',
        :password              => 'hellyhollyhally',
        :password_confirmation => 'hellyhollyhally'
      )
      assert_equal(team, user.teams.last)
      assert(user.persisted?)
      user.skip_current_password = true
      assert(user.valid?)
      team.mateships.reload
      assert_includes(team.mateships.pluck(:user_id), user.id)
    end

    def test_load_from_reset_password_token_without_token
      user = user_with_schema(:oswald)
      user.update_columns(
        :reset_password_token            => 'token',
        :reset_password_token_expires_at => Time.now + 3.hours
      )
      assert_nil(User.load_from_reset_password_token(nil))
    end

    def test_load_from_reset_password_token_with_invalid_token
      user = user_with_schema(:oswald)
      user.update_columns(
        :reset_password_token            => 'token',
        :reset_password_token_expires_at => Time.now + 3.hours
      )
      assert_nil(User.load_from_reset_password_token('unknown'))
    end

    def test_load_from_reset_password_token_with_expired_token
      user = user_with_schema(:oswald)
      user.update_columns(
        :reset_password_token            => 'token',
        :reset_password_token_expires_at => Time.now - 3.hours
      )
      assert_nil(User.load_from_reset_password_token('token'))
    end

    def test_load_from_reset_password_token
      user = user_with_schema(:oswald)
      attributes = {
        :reset_password_token            => 'token',
        :reset_password_token_expires_at => Time.now + 3.hours
      }
      user.update_columns(attributes)
      result = User.load_from_reset_password_token('token')
      assert_equal(user, result)
    end

    def test_change_password_without_current_password
      user = user_with_schema(:oswald)
      assert(user.authenticate('secret'))
      refute(user.change_password!(
        :password              => 'moresecret',
        :password_confirmation => 'moresecret'
      ))
      assert_equal(
        ['is not correct'],
        user.errors[:current_password]
      )
    end

    def test_change_password_with_wrong_password_confirmation
      user = user_with_schema(:oswald)
      assert(user.authenticate('secret'))
      refute(user.change_password!(
        :current_password      => 'secret',
        :password              => 'moresecret',
        :password_confirmation => 'littlesecret'
      ))
      assert_equal(
        ['doesn\'t match Password'],
        user.errors[:password_confirmation]
      )
    end

    def test_change_password_update_password_digest
      user = user_with_schema(:oswald)
      assert(user.authenticate('secret'))
      old_digest = user.password_digest
      assert(user.change_password!(
        :current_password      => 'secret',
        :password              => 'moresecret',
        :password_confirmation => 'moresecret'
      ))
      assert_not_equal(old_digest, user.password_digest)
    end

    def test_reset_password_generates_random_token
      set_url_options_for_mailer
      user = user_with_schema(:oswald)
      assert_nil(user.reset_password_token)
      user.reset_password!
      refute_nil(user.reset_password_token)
      refute_match(/[\+\/=1lIO0]+/, user.reset_password_token)
    end

    def test_reset_password_sets_expires_at_as_after_1_hour
      set_url_options_for_mailer
      user = user_with_schema(:oswald)
      now = Time.new(2016, 03, 14, 10, 00, 00, '+00:00')
      Time.stubs(:now).returns(now)
      user.expects(:send_reset_password_email!).once
      assert_nil(user.reset_password_token_expires_at)
      user.reset_password!
      assert_equal(
        now.in_time_zone + 1.hour,
        user.reset_password_token_expires_at
      )
    end

    def test_validate_email_except_uniqueness_with_error
      user = user_with_schema(:oswald)
      user.email = 'invalid'
      refute(user.validate_email_except_uniqueness)
      assert_equal(
        ['is invalid'],
        user.errors[:email]
      )
    end

    def test_validate_email_except_uniqueness_with_duplicated_email
      user = user_with_schema(:oswald)
      mate = user.teams.first.mates.new(
        :email => user.email
      )
      assert(mate.validate_email_except_uniqueness)
      assert_empty(mate.errors[:email])
    end

    def test_validate_current_password
      user = user_with_schema(:oswald)
      user.current_password = 'invalid'
      refute(user.validate_current_password)
      assert_equal(
        ['is not correct'],
        user.errors[:current_password]
      )
    end

    private

    def set_url_options_for_mailer
      ActionMailer::Base.default_url_options[:host] = ENV['TEST_HOST']
    end
  end
end
