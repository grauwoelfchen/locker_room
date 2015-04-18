require "houser"
require "sorcery"

module LockerRoom
  class Engine < ::Rails::Engine
    isolate_namespace LockerRoom

    initializer "locker_room.middleware.houser" do
      Rails.application.config.middleware.use Houser::Middleware,
        :class_name => "LockerRoom::Account"
    end

    config.to_prepare do
      root = LockerRoom::Engine.root
      # extenders
      Dir.glob(root + "app/extenders/**/*.rb") do |file|
        Rails.configuration.cache_classes ? require(file) : load(file)
      end
    end
  end
end
