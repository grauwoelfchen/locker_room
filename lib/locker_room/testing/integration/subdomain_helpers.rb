module LockerRoom
  module Testing
    module Integration
module SubdomainHelpers
  def within_subdomain(subdomain)
    host = subdomain_host(subdomain)

    app_host = Capybara.app_host
    Capybara.app_host = host
    default_url_host = locker_room.scope.default_url_options[:host]
    locker_room.scope.default_url_options[:host] = host

    yield

    locker_room.scope.default_url_options[:host] = default_url_host
    Capybara.app_host = app_host
  end

  private

  def subdomain_host(subdomain)
    uri = URI.parse(Capybara.app_host)
    tld_length = Rails.application.config.action_dispatch.tld_length ||
                 ActionDispatch::Http::URL.tld_length
    # Enable host like: foo.127.0.0.1.xip.io
    host = uri.host.split(".").last(tld_length + 1).join(".")
    "#{uri.scheme}://#{subdomain}.#{host}:#{uri.port}"
  end
end
    end
  end
end
