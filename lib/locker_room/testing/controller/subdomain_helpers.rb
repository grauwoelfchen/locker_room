require "rack/mock"
require "houser/middleware"

module LockerRoom
  module Testing
    module Controller
module SubdomainHelpers
  def within_subdomain(subdomain)
    subdomain_host = "#{subdomain}.example.org"
    # request
    request_host = @request.host
    @request.host = subdomain_host
    # env
    original_env = @controller.env
    @controller.env = env_for(subdomain_host)
    # url_options
    default_host = @routes.default_url_options[:host]
    @routes.default_url_options[:host] = subdomain_host
    yield
    # restore request, env and url_options
    @controller.request.host = @request.host = request_host
    @controller.env = original_env
    @routes.default_url_options[:host] = default_host
  end

  private

  # https://github.com/radar/houser/blob/master/spec/houser_spec.rb
  # http://rack.rubyforge.org/doc/Rack/MockRequest.html#method-c-env_for
  def env_for(host, opts={})
    app = ->(env) { [200, env, "app"] }
    options = {:class_name => "LockerRoom::Team"}
    middleware = Houser::Middleware.new(app, options)
    opts.merge!("HTTP_HOST" => host)
    _, env = middleware.call(Rack::MockRequest.env_for("http://" + host, opts))
    @controller.env = env
  end
end
    end
  end
end
