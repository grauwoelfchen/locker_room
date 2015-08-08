require "test_helper"

class AccountLogoutTest < Capybara::Rails::TestCase
  locker_room_fixtures(:teams, :users, :mateships)

  def test_logout
    user = user_with_schema(:oswald)
    within_subdomain(user.team.subdomain) do
      visit(locker_room.login_url)
      assert_equal(locker_room.login_url, page.current_url)
      fill_in("Email",   :with => user.email)
      fill_in("Password",:with => "secret")
      click_button("Signin")
      assert_equal(locker_room.root_url, page.current_url)
      click_logout
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Logged out.")
    end
  end
end
