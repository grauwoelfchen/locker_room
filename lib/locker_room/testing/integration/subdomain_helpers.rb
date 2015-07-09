module LockerRoom
  module Testing
    module Integration
module SubdomainHelpers
  def within_subdomain(subdomain)
    uri = URI.parse(Capybara.app_host)
    host = uri.host.split(".").last(2).join(".")
    subdomain_host = "#{uri.scheme}://#{subdomain}.#{host}"

    app_host = Capybara.app_host
    Capybara.app_host = subdomain_host
    default_host = locker_room.scope.default_url_options[:host]
    locker_room.scope.default_url_options[:host] = subdomain_host
    yield
    locker_room.scope.default_url_options[:host] = default_host
    Capybara.app_host = app_host
  end
end
    end
  end
end
