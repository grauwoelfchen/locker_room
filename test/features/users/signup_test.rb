require "test_helper"

class UserSignupTest < Capybara::Rails::TestCase
  locker_room_fixtures(:accounts, :members, :users)

  def test_validation_with_duplicated_email
    account = account_with_schema(:penguin_patrol)
    within_subdomain(account.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.login_url, page.current_url)
      click_link("New User?")
      assert_equal(locker_room.signup_url, page.current_url)
      fill_in("Username",              :with => "henry")
      fill_in("Email",                 :with => "henry@example.org")
      fill_in("Password",              :with => "slowandsteady")
      fill_in("Password confirmation", :with => "slowandsteady")
      click_button("Signup")
      assert_content("Your user account could not be created.")
      assert_equal(locker_room.signup_url, page.current_url)
    end
  end

  def test_user_signup
    account = account_with_schema(:penguin_patrol)
    within_subdomain(account.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.login_url, page.current_url)
      click_link("New User?")
      assert_equal(locker_room.signup_url, page.current_url)
      fill_in("Username",              :with => "louie")
      fill_in("Email",                 :with => "louie@example.org")
      fill_in("Password",              :with => "nomorenoless")
      fill_in("Password confirmation", :with => "nomorenoless")
      click_button("Signup")
      assert_content("You have signed up successfully.")
      assert_equal(locker_room.root_url, page.current_url)
      logout_user(locker_room.logout_url, :delete)
    end
  end
end
