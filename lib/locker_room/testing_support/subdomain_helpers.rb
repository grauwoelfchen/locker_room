module LockerRoom
  module TestingSupport
    module SubdomainHelpers
      def within_account_subdomain(subdomain)
        subdomain_host = "http://#{subdomain}.example.org"
        app_host = Capybara.app_host
        Capybara.app_host = subdomain_host
        yield
        Capybara.app_host = app_host
      end
    end
  end
end
