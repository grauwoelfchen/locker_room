require "test_helper"

class ScopTest < Capybara::Rails::TestCase
  locker_room_fixtures(:teams, :users, :mateships)

  def setup
    @team_piano   = team_with_schema(:playing_piano)
    @team_penguin = team_with_schema(:penguin_patrol)

    Apartment::Tenant.switch!(@team_piano.subdomain)
    Talk.create(:theme => "Musical instrument")
    Apartment::Tenant.switch!(@team_penguin.subdomain)
    Talk.create(:theme => "The ice")
    Apartment::Tenant.reset
  end

  def teardown
    logout_user
  end

  def test_scoped_visibility_for_team_piano
    user = @team_piano.owners.first
    login_user(user)
    visit(main_app.talks_url(:subdomain => @team_piano.subdomain))
    assert_content("Musical instrument")
    refute_content("The ice")
  end

  def test_scoped_visibility_for_team_penguin
    user = @team_penguin.owners.first
    login_user(user)
    visit(main_app.talks_url(:subdomain => @team_penguin.subdomain))
    refute_content("Musical instrument")
    assert_content("The ice")
  end
end
