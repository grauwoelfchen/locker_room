require 'apartment/elevators/subdomain'

require 'apartment'
require 'houser'
require 'sorcery'
require 'enum_accessor'

module Apartment
  module Elevators
    class UnderscoreSubdomain < Subdomain
      alias_method :orig_parse_tenant_name, :parse_tenant_name
      def parse_tenant_name(request)
        Apartment.tld_length =
          Rails.application.config.action_dispatch.tld_length ||
          ActionDispatch::Http::URL.tld_length ||
          Apartment.tld_length
        name = orig_parse_tenant_name(request)
        name.gsub!(/\-/, '_') if name
        name
      end
    end
  end
end

module LockerRoom
  class Engine < ::Rails::Engine
    isolate_namespace LockerRoom

    initializer 'locker_room.middleware.apartment' do
      Rails.application.config.middleware.use \
        'Apartment::Elevators::UnderscoreSubdomain'
    end

    # If you change tld_length, set
    # config.action_dispatch.tld_length in environments/{env}.rb
    initializer 'locker_room.middleware.houser' do
      Rails.application.config.middleware.use 'Houser::Middleware',
        :class_name => 'LockerRoom::Team',
        :tld_length => \
          Rails.application.config.action_dispatch.tld_length ||
          ActionDispatch::Http::URL.tld_length
    end

    config.to_prepare do
      root = LockerRoom::Engine.root
      # extenders
      Dir.glob(root + 'app/extenders/**/*.rb') do |file|
        Rails.configuration.cache_classes ? require(file) : load(file)
      end
    end
  end
end
