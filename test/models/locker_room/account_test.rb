require "test_helper"

module LockerRoom
  class AccountTest < ActiveSupport::TestCase
    locker_room_fixtures(:accounts, :members, :users)

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
        message = "#{subdomain} is not allowed"
        error = "subdomain restriction is failed: #{subdomain}"
        assert_equal([message], account.errors[:subdomain], error)
      end
    end

    def test_validation_with_with_invalid_subdomain
      account = LockerRoom::Account.new(:subdomain => '[foo]')
      refute(account.valid?)
      message = "[foo] is not allowed"
      assert_equal([message], account.errors[:subdomain])
    end

    def test_subdomain_downcase_before_validation
      account = LockerRoom::Account.new(:subdomain => 'TEST')
      refute(account.valid?)
      assert_equal('test', account.subdomain)
      message = "test is not allowed"
      assert_equal([message], account.errors[:subdomain])
    end

    def test_creation_without_owners
      account = LockerRoom::Account.create_with_owner
      refute(account.valid?)
      refute(account.persisted?)
      assert(account.users.empty?)
    end

    def test_creation_with_an_owner
      attrs = {
        :name             => "Unicycle",
        :subdomain        => "unicycle",
        :owners_attributes => {
          :"0" => {
            :email                 => "daisy@example.org",
            :password              => "hellyhollyhally",
            :password_confirmation => "hellyhollyhally"
          }
        }
      }
      account = LockerRoom::Account.create_with_owner(attrs)
      assert(account.valid?)
      assert(account.persisted?)
      owner = account.owners.where(:email => "daisy@example.org").take!
      assert_includes(account.users.pluck(:id), owner.id)
    end

    def test_creation_of_schema
      account = LockerRoom::Account.create!(
        :name      => "Unicycle",
        :subdomain => "unicycle"
      )
      account.create_schema
      message = "Schema #{account.schema_name} does not exist"
      assert(schema_exists?(account), message)
    end

    private

    def schema_exists?(account)
      query = %Q(
SELECT nspname FROM pg_namespace
WHERE nspname = '#{account.subdomain}'
      )
      result = ActiveRecord::Base.connection.select_value(query)
      result.present?
    end
  end
end
