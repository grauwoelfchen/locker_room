module LockerRoom
  module Testing
    module Integration
module AuthenticationHelpers
  private

  def login_user(user=nil, subdomain=nil, route=nil, http_method=:post)
    # subdomain route support
    if user && !route
      route = locker_room.login_url(:subdomain => subdomain)
    end
    user ||= @user
    route ||= locker_room.login_url
    user_params = {:email => user.email, :password => 'secret'}
    page.driver.send(http_method, route, user_params)
  end

  def logout_user(route=nil, http_method=:get)
    # subdomain route support
    if page && !route
      route = detect_logout_url
    end
    route ||= locker_room.logout_url
    page.driver.send(http_method, route)
  end

  def detect_logout_url
    host = Capybara.app_host.sub(/^https?:\/\//, '')
    subdomain = page.driver.request.env['HTTP_HOST'].sub(".#{host}", '')
    return nil unless subdomain.present?
    team = LockerRoom::Team.find_by(subdomain: subdomain)
    return nil unless team
    locker_room.logout_url(:subdomain => team.subdomain)
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
