require "test_helper"

module LockerRoom
  class AccountTest < ActiveSupport::TestCase
    fixtures("locker_room/accounts")

    def test_validation_with_without_name
      account = LockerRoom::Account.new(:name => nil)
      refute(account.valid?)
      message = "can't be blank"
      assert_equal([message], account.errors[:name])
    end

    def test_validation_with_with_too_long_name
      account = LockerRoom::Account.new(:name => "long" * 9)
      refute(account.valid?)
      message = "is too long (maximum is 32 characters)"
      assert_equal([message], account.errors[:name])
    end

    def test_validation_with_without_subdomain
      account = LockerRoom::Account.new(:subdomain => nil)
      refute(account.valid?)
      message = "can't be blank"
      assert_equal([message], account.errors[:subdomain])
    end

    def test_validation_with_with_duplicated_subdomain
      penguin = locker_room_accounts(:penguin_patrol)

      account = LockerRoom::Account.new(:subdomain => penguin.subdomain)
      refute(account.valid?)
      message = "has already been taken"
      assert_equal([message], account.errors[:subdomain])
    end

    def test_validation_with_with_too_short_subdomain
      account = LockerRoom::Account.new(:subdomain => 'sh')
      refute(account.valid?)
      message = "is too short (minimum is 3 characters)"
      assert_equal([message], account.errors[:subdomain])
    end

    def test_validation_with_with_too_long_subdomain
      account = LockerRoom::Account.new(:subdomain => 'long' * 17)
      refute(account.valid?)
      message = "is too long (maximum is 64 characters)"
      assert_equal([message], account.errors[:subdomain])
    end

    def test_validation_with_with_restricted_subdomain
      exclude_subdomains = %w[admin test www new]

      exclude_subdomains.map do |subdomain|
        account = LockerRoom::Account.new(:subdomain => subdomain)
        refute(account.valid?)
        message = "is not allowed"
        error = "subdomain restriction is failed: #{subdomain}"
        assert_equal([message], account.errors[:subdomain], error)
      end
    end

    def test_validation_with_with_invalid_subdomain
      account = LockerRoom::Account.new(:subdomain => '[foo]')
      refute(account.valid?)
      message = "is not allowed"
      assert_equal([message], account.errors[:subdomain])
    end

    def test_downcasing_before_validation
      account = LockerRoom::Account.new(:subdomain => 'TEST')
      refute(account.valid?)
      assert_equal('test', account.subdomain)
      message = "is not allowed"
      assert_equal([message], account.errors[:subdomain])
    end

    def test_creation_without_owner
      account = LockerRoom::Account.new
      refute(account.save_with_owner)
      refute(account.persisted?)
      assert(account.users.empty?)
    end

    def test_creation_with_an_owner
      attrs = {
        :name             => "Unicycle",
        :subdomain        => "unicycle",
        :owner_attributes => {
          :email                 => "daisy@example.org",
          :password              => "hellyhollyhally",
          :password_confirmation => "hellyhollyhally"
        }
      }
      account = LockerRoom::Account.new(attrs)
      assert(account.save_with_owner)
      assert(account.persisted?)
      assert_equal(account.owner, account.users.first)
    end
  end
end
