$:.push File.expand_path('../lib', __FILE__)

require 'locker_room/version'

Gem::Specification.new do |s|
  s.name        = 'locker_room'
  s.version     = LockerRoom::VERSION
  s.authors     = ['Yasuhiro Asaka']
  s.email       = ['grauwoelfchen@gmail.com']
  s.homepage    = 'https://github.com/grauwoelfchen/locker_room'
  s.license     = 'MIT'
  s.summary     = <<-SUMMARY
Rails engine which provides user ojects for team
SUMMARY
  s.description = <<-DESCRIPTION
LockerRoom is a mountable rails engine which provides
user objects (team, user) and subscription for team.
DESCRIPTION

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2.1'
  s.add_dependency 'pg', '~> 0.18'
  s.add_dependency 'apartment', '~> 1.0.2'
  s.add_dependency 'enum_accessor', '~> 2.0'
  s.add_dependency 'sorcery','~> 0.9.1'
  s.add_dependency 'houser', '~> 2.0'
  s.add_dependency 'braintree', '2.49.0'

  s.add_development_dependency 'foreman'
  s.add_development_dependency 'minitest', '~> 5.5'
  s.add_development_dependency 'minitest-rails-capybara'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'fake_braintree'
  s.add_development_dependency 'travis'
  s.add_development_dependency 'codeclimate-test-reporter'
end
