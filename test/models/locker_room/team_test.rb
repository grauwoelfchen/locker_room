require 'test_helper'

module LockerRoom
  class TeamTest < ActiveSupport::TestCase
    locker_room_fixtures(:teams, :users, :mateships)

    def test_validation_without_name
      team = LockerRoom::Team.new(:name => nil)
      refute(team.valid?)
      message = 'can\'t be blank'
      assert_equal([message], team.errors[:name])
    end

    def test_validation_with_too_long_name
      team = LockerRoom::Team.new(:name => 'long' * 9)
      refute(team.valid?)
      message = 'is too long (maximum is 32 characters)'
      assert_equal([message], team.errors[:name])
    end

    def test_validation_without_subdomain
      team = LockerRoom::Team.new(:subdomain => nil)
      refute(team.valid?)
      message = 'can\'t be blank'
      assert_equal([message], team.errors[:subdomain])
    end

    def test_validation_with_duplicated_subdomain
      other_team = locker_room_teams(:penguin_patrol)
      team = LockerRoom::Team.new(:subdomain => other_team.subdomain)
      refute(team.valid?)
      message = 'has already been taken'
      assert_equal([message], team.errors[:subdomain])
    end

    def test_validation_with_too_short_subdomain
      team = LockerRoom::Team.new(:subdomain => 'sh')
      refute(team.valid?)
      message = 'is too short (minimum is 3 characters)'
      assert_equal([message], team.errors[:subdomain])
    end

    def test_validation_with_too_long_subdomain
      team = LockerRoom::Team.new(:subdomain => 'long' * 17)
      refute(team.valid?)
      message = 'is too long (maximum is 64 characters)'
      assert_equal([message], team.errors[:subdomain])
    end

    def test_validation_with_restricted_subdomain
      exclude_subdomains = %w[admin test www new]
      exclude_subdomains.map do |subdomain|
        team = LockerRoom::Team.new(:subdomain => subdomain)
        refute(team.valid?)
        message = "#{subdomain} is not allowed"
        error = 'subdomain restriction is failed: #{subdomain}'
        assert_equal([message], team.errors[:subdomain], error)
      end
    end

    def test_validation_with_invalid_subdomain
      team = LockerRoom::Team.new(:subdomain => '[foo]')
      refute(team.valid?)
      message = '[foo] is not allowed'
      assert_equal([message], team.errors[:subdomain])
    end

    def test_subdomain_downcase_before_validation
      team = LockerRoom::Team.new(:subdomain => 'TEST')
      refute(team.valid?)
      assert_equal('test', team.subdomain)
      message = 'test is not allowed'
      assert_equal([message], team.errors[:subdomain])
    end

    def test_creation_without_owners
      team = LockerRoom::Team.create_with_owner
      refute(team.valid?)
      refute(team.persisted?)
      assert(team.users.empty?)
    end

    def test_creation_with_an_owner
      attributes = {
        :name              => 'Unicycle',
        :subdomain         => 'unicycle',
        :owners_attributes => {
          :'0' => {
            :username              => 'daisy',
            :email                 => 'daisy@example.org',
            :password              => 'hellyhollyhally',
            :password_confirmation => 'hellyhollyhally'
          }
        }
      }
      team = LockerRoom::Team.create_with_owner(attributes)
      assert(team.valid?)
      assert(team.persisted?)
      owner = team.owners.where(:email => 'daisy@example.org').take!
      assert_includes(team.users.pluck(:id), owner.id)
    end

    def test_creation_of_schema
      team = LockerRoom::Team.create!(
        :name      => 'Unicycle',
        :subdomain => 'unicycle'
      )
      team.create_schema
      message = "Schema #{team.schema_name} does not exist"
      assert(schema_exists?(team), message)
    end

    private

    def schema_exists?(team)
      query = %Q(
SELECT nspname FROM pg_namespace
WHERE nspname = '#{team.subdomain}'
      )
      result = ActiveRecord::Base.connection.select_value(query)
      result.present?
    end
  end
end
