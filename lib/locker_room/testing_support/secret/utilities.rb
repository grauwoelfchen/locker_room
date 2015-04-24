require "sorcery/crypto_providers/bcrypt"

module LockerRoom
  module TestingSupport
    module Secret
module Utilities
  def salt_for(user)
    secret_hash[user.to_s]["salt"]
  rescue NoMethodError
    raise Secret::FixtureNotFound
  end

  def crypted_password_for(user)
    password = secret_hash[user.to_s]["password"]
    Sorcery::CryptoProviders::BCrypt.encrypt(password, salt_for(user))
  rescue NoMethodError
    raise Secret::FixtureNotFound
  end

  def secret_hash
    @secret_hash ||= begin
      fixture_path = ActiveSupport::TestCase.fixture_path
      secret_file = fixture_path + "/locker_room/.secret.yml"
      YAML.load(ERB.new(File.read(secret_file)).result)
    rescue Errno::ENOENT, Psych::SyntaxError
      raise Secret::FixtureFileNotFoundOrBroken
    end
  end
end
    end
  end
end
