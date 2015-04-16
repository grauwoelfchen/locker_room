$:.push File.expand_path("../lib", __FILE__)

require "locker_room/version"

Gem::Specification.new do |s|
  s.name        = "locker_room"
  s.version     = LockerRoom::VERSION
  s.authors     = ["Yasuhiro Asaka"]
  s.email       = ["grauwoelfchen@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of LockerRoom."
  s.description = "TODO: Description of LockerRoom."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "minitest", "~> 5.5"
  s.add_development_dependency "minitest-rails-capybara"
  s.add_development_dependency "database_cleaner"
end
