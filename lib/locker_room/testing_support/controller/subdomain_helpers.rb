require "rack/mock"
require "houser/middleware"

require "locker_room/engine"

module LockerRoom
  module TestingSupport
    module Controller
module SubdomainHelpers
  def within_subdomain(subdomain)
    subdomain_host = "http://#{subdomain}.example.org"
    @routes ||= LockerRoom::Engine.routes

    original_env = @controller.env
    @controller.env = env_for(subdomain_host)
    default_host = @routes.default_url_options[:host]
    @routes.default_url_options[:host] = subdomain_host
    yield
    @routes.default_url_options[:host] = default_host
    @controller.env = original_env
  end

  private

    # see https://github.com/radar/houser/blob/master/spec/houser_spec.rb
    def env_for(url, opts={})
      app = ->(env) { [200, env, "app"] }
      options = {:class_name => "LockerRoom::Account"}
      middleware = Houser::Middleware.new(app, options)
      opts.merge!("HTTP_HOST" => URI.parse(url).host)
      _, env = middleware.call(Rack::MockRequest.env_for(url, opts))
      @controller.env = env
    end
end
    end
  end
end
