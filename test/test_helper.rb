ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [
  File.expand_path("../../test/dummy/db/migrate", __FILE__),
  File.expand_path('../../db/migrate', __FILE__)
]
require "rails/test_help"

require "minitest/mock"
require "minitest/rails/capybara"
require "minitest/pride" if ENV["TEST_PRIDE"].present?
require "database_cleaner"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
test_dir = File.dirname(__FILE__)
Dir["#{test_dir}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = test_dir + "/fixtures"
  # ActiveSupport::TestCase.fixtures :all
end

class ActiveSupport::TestCase
  include LockerRoom::Testing::FixtureHelpers

  ActiveRecord::Migration.check_pending!
  DatabaseCleaner.strategy = :truncation

  def before_setup
    super
    DatabaseCleaner.start
  end

  def after_teardown
    Apartment::Tenant.reset
    DatabaseCleaner.clean
    clean_all_schema
    super
  end

  private

  def clean_all_schema
    connection = ActiveRecord::Base.connection.raw_connection
    schemas = connection.query(%Q{
      SELECT 'DROP SCHEMA ' || nspname || ' CASCADE;'
      FROM pg_namespace
      WHERE nspname != 'public'
      AND nspname NOT LIKE 'pg_%'
      AND nspname != 'information_schema';
    })
    schemas.each do |query|
      # DROP SCHEMA [NAME] CASCADE;
      connection.query(query.values.first)
    end
  end
end

class ActionController::TestCase
  include LockerRoom::Testing::Controller::SubdomainHelpers
  include LockerRoom::Testing::Controller::AuthenticationHelpers

  def setup
    @routes = LockerRoom::Engine.routes
    super
  end
end

Capybara.configure do |config|
  config.app_host = "http://example.org"
end

class Capybara::Rails::TestCase
  include LockerRoom::Testing::Integration::SubdomainHelpers
  include LockerRoom::Testing::Integration::AuthenticationHelpers

  def before_setup
    @default_host = locker_room.scope.default_url_options[:host]
    locker_room.scope.default_url_options[:host] = Capybara.app_host
    super
  end

  def after_teardown
    super
    locker_room.scope.default_url_options[:host] = @default_host
  end
end
