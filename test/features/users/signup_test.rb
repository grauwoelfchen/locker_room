require "test_helper"

class UserSignupTest < Capybara::Rails::TestCase
  fixtures("locker_room/accounts", "locker_room/members", "locker_room/users")

  def test_validation_with_duplicated_email
    account = locker_room_accounts(:penguin_patrol)
    within_account_subdomain(account.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.login_url, page.current_url)
      click_link("New User?")
      assert_equal(locker_room.signup_url, page.current_url)
      fill_in("Email",                 :with => "henry@example.org")
      fill_in("Password",              :with => "slowandsteady")
      fill_in("Password confirmation", :with => "slowandsteady")
      click_button("Signup")
      assert_content("Sorry, your user account could not be created.")
      assert_equal(locker_room.signup_url, page.current_url)
      logout_user(locker_room.logout_url)
    end
  end

  def test_user_signup
    account = locker_room_accounts(:penguin_patrol)
    within_account_subdomain(account.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.login_url, page.current_url)
      click_link("New User?")
      assert_equal(locker_room.signup_url, page.current_url)
      fill_in("Email",                 :with => "louie@example.org")
      fill_in("Password",              :with => "north")
      fill_in("Password confirmation", :with => "north")
      click_button("Signup")
      assert_content("You have signed up successfully.")
      assert_equal(locker_room.root_url, page.current_url)
      logout_user(locker_room.logout_url)
    end
  end
end
