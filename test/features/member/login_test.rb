require "test_helper"

class MemberLoginTest < Capybara::Rails::TestCase
  locker_room_fixtures(:teams, :users, :memberships)

  def test_validation_at_login_attempt_as_owner_with_invalid_email
    team = team_with_schema(:playing_piano)
    within_subdomain(team.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => team.subdomain)
      click_button("Continue")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Please signin.")
      fill_in("Email",   :with => "henry@example.org")
      fill_in("Password",:with => "secret")
      click_button("Signin")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Email or password is invalid.")
      logout_user(locker_room.logout_url, :delete)
    end
  end

  def test_validation_at_login_attempt_as_owner_with_invalid_password
    team = team_with_schema(:playing_piano)
    within_subdomain(team.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => team.subdomain)
      click_button("Continue")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Please signin.")
      fill_in("Email",   :with => team.owners.first.email)
      fill_in("Password",:with => "invalid")
      click_button("Signin")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Email or password is invalid.")
      logout_user(locker_room.logout_url, :delete)
    end
  end

  def test_validation_at_login_attempt_as_owner_with_other_subdomain
    team       = team_with_schema(:penguin_patrol)
    other_team = team_with_schema(:playing_piano)
    within_subdomain(other_team.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => other_team.subdomain)
      click_button("Continue")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Please signin.")
      fill_in("Email",   :with => team.owners.first.email)
      fill_in("Password",:with => "secret")
      click_button("Signin")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Email or password is invalid.")
      logout_user(locker_room.logout_url, :delete)
    end
  end

  def test_login_as_owner
    team = team_with_schema(:playing_piano)
    within_subdomain(team.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => team.subdomain)
      click_button("Continue")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Please signin.")
      fill_in("Email",   :with => team.owners.first.email)
      fill_in("Password",:with => "secret")
      click_button("Signin")
      assert_equal(locker_room.root_url, page.current_url)
      assert_content("You are now signed in.")
      logout_user(locker_room.logout_url, :delete)
    end
  end

  def test_validation_at_login_attempt_as_member_with_invalid_email
    user = user_with_schema(:weenie)
    within_subdomain(user.team.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => user.team.subdomain)
      click_button("Continue")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Please signin.")
      fill_in("Email",   :with => "henry@example.org")
      fill_in("Password",:with => "secret")
      click_button("Signin")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Email or password is invalid.")
      logout_user(locker_room.logout_url, :delete)
    end
  end

  def test_validation_at_login_attempt_as_member_with_invalid_password
    user = user_with_schema(:weenie)
    within_subdomain(user.team.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => user.team.subdomain)
      click_button("Continue")
      assert_content("Please signin.")
      assert_equal(locker_room.login_url, page.current_url)
      fill_in("Email",   :with => user.email)
      fill_in("Password",:with => "invalid")
      click_button("Signin")
      assert_content("Email or password is invalid.")
      assert_equal(locker_room.login_url, page.current_url)
      logout_user(locker_room.logout_url, :delete)
    end
  end

  def test_login_as_member
    user = user_with_schema(:weenie)
    within_subdomain(user.team.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => user.team.subdomain)
      click_button("Continue")
      assert_equal(locker_room.login_url, page.current_url)
      fill_in("Email",   :with => user.email)
      fill_in("Password",:with => "secret")
      click_button("Signin")
      assert_content("You are now signed in.")
      assert_equal(locker_room.root_url, page.current_url)
      logout_user(locker_room.logout_url, :delete)
    end
  end
end
