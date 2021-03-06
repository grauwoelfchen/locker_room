require 'rack/mock'
require 'houser/middleware'

module LockerRoom
  module Testing
    module Controller
module SubdomainHelpers
  def within_subdomain(subdomain)
    uri = URI.parse(@request.url)
    host = uri.host.split('.').last(2).join('.')
    subdomain_host = "#{subdomain}.#{host}"

    # request
    request_host = @request.host
    @request.host = subdomain_host
    # env
    original_env = @request.env
    new_env      = env_for(subdomain_host, {
      'warden' => @request.env['warden']})
    @request.instance_variable_set(:@env, new_env)
    # url_options
    default_host = @routes.default_url_options[:host]
    @routes.default_url_options[:host] = subdomain_host
    yield
    # restore request, env and url_options
    @request.host = @request.host = request_host
    @request.instance_variable_set(:@env, original_env)
    @routes.default_url_options[:host] = default_host
  end

  private

  # https://github.com/radar/houser/blob/master/spec/houser_spec.rb
  # http://rack.rubyforge.org/doc/Rack/MockRequest.html#method-c-env_for
  def env_for(host, opts={})
    app = ->(env) { [200, env, 'app'] }
    middleware = Houser::Middleware.new(app, {
      :class_name => 'LockerRoom::Team'})
    opts.merge!('HTTP_HOST' => host)
    _, env = \
      middleware.call(Rack::MockRequest.env_for('http://' + host, opts))
    env
  end
end
    end
  end
end
