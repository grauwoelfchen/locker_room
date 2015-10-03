module LockerRoom
  module Testing
    module Integration
module AuthenticationHelpers
  include Sorcery::TestHelpers::Rails::Integration

  private

    alias_method :orig_login_user, :login_user
    def login_user(user=nil, route=nil, http_method=:post)
      # subdomain route support
      if user && !route
        route = locker_room.login_url(:subdomain => user.team.subdomain)
      end
      orig_login_user(user, route, http_method)
    end

    alias_method :orig_logout_user, :logout_user
    def logout_user(route=nil, http_method=:get)
      # subdomain route support
      if page && !route
        host = Capybara.app_host.sub(/^https?:\/\//, '')
        subdomain = page.driver.request.env['HTTP_HOST'].sub(".#{host}", '')
        if subdomain.present? &&
           team = LockerRoom::Team.find_by(subdomain: subdomain)
          route = locker_room.logout_url(:subdomain => team.subdomain)
        else
          route = locker_room.logout_url
        end
      end
      orig_logout_user(route, http_method)
    end

    def click_logout
      logout_user(locker_room.logout_url, :delete)
      # redirect link
      assert_content('You are being redirected.')
      click_link('redirected')
    end
end
    end
  end
end
