require 'test_helper'

class LoginTest < Capybara::Rails::TestCase
  locker_room_fixtures(:teams)

  def test_team_not_found
    visit(locker_room.login_url(:subdomain => nil))
    assert_equal('http://example.org/signin', page.current_url)
    fill_in('Subdomain', :with => 'www')
    click_button('Continue')
    assert_equal('http://example.org/signin', page.current_url)
    assert_content('Team is not found.')
  end

  def test_team_login
    visit(locker_room.login_url(:subdomain => nil))
    assert_equal('http://example.org/signin', page.current_url)
    team = locker_room_teams(:playing_piano)
    team.create_schema
    fill_in('Subdomain', :with => team.subdomain)
    click_button('Continue')
    login_url = "http://#{team.subdomain}.example.org/signin"
    assert_equal(login_url, page.current_url)
    assert_content('Please signin.')
  end
end
