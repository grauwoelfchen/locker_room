require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../test/dummy/config/environment.rb',  __FILE__)
ActiveRecord::Migrator.migrations_paths = [
  File.expand_path('../../test/dummy/db/migrate', __FILE__),
  File.expand_path('../../db/migrate', __FILE__)
]

require 'rails/test_help'

require 'minitest/unit'
require 'minitest/mock'
require 'minitest/rails/capybara'
require 'minitest/pride' if ENV['TEST_PRIDE'].present?
require 'mocha/mini_test'
require 'database_cleaner'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
test_dir = File.dirname(__FILE__)
Dir["#{test_dir}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = test_dir + '/fixtures'
  # ActiveSupport::TestCase.fixtures :all
end

class ActiveSupport::TestCase
  include LockerRoom::Testing::FixtureHelpers

  ActiveRecord::Migration.check_pending!
  DatabaseCleaner.clean_with(:truncation)
  DatabaseCleaner.strategy = :transaction

  def before_setup
    super
    DatabaseCleaner.start
  end

  def after_teardown
    Apartment::Tenant.reset
    clean_all_schema
    DatabaseCleaner.clean
    super
  end

  def clean_all_schema
    LockerRoom::Team.all.map do |team|
      conn = ActiveRecord::Base.connection
      conn.query(%Q{DROP SCHEMA IF EXISTS #{team.schema_name} CASCADE;})
    end
  end
end

class ActionController::TestCase
  include LockerRoom::Testing::Controller::WardenHelpers
  include LockerRoom::Testing::Controller::SubdomainHelpers
  include LockerRoom::Testing::Controller::AuthenticationHelpers

  def setup
    @routes = LockerRoom::Engine.routes
    super
  end
end

ENV['BRAINTREE_GATEWAY_PORT'] ||= '45678'

Capybara.configure do |config|
  config.app_host              = 'http://example.org'
  config.run_server            = false
  config.server_port           = 3001
  config.default_max_wait_time = 6 # seconds (default: 2)
end

require 'fake_braintree'
FakeBraintree.activate!(gateway_port: ENV['BRAINTREE_GATEWAY_PORT'])

# https://github.com/highfidelity/fake_braintree/issues/18#issuecomment-13776245
class PortMap
  def initialize(default_app, mappings)
    @default_app = default_app
    @mappings = mappings
  end

  def call(env)
    request = Rack::Request.new(env)
    port = request.port
    app = @mappings[port] || @default_app
    app.call(env)
  end
end

original_app = Capybara.app

Capybara.app = PortMap.new(
  original_app,
  ENV['BRAINTREE_GATEWAY_PORT'].to_i => FakeBraintree::SinatraApp
)

class Capybara::Rails::TestCase
  include LockerRoom::Testing::Integration::SubdomainHelpers
  include LockerRoom::Testing::Integration::AuthenticationHelpers

  def before_setup
    FakeBraintree.clear!
    @default_host = locker_room.scope.default_url_options[:host]
    locker_room.scope.default_url_options[:host] = Capybara.app_host
    super
  end

  def after_teardown
    super
    Capybara.reset_session!
    locker_room.scope.default_url_options[:host] = @default_host
  end
end
