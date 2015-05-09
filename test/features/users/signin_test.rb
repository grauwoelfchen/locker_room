require "test_helper"

class UserSigninTest < Capybara::Rails::TestCase
  locker_room_fixtures(:accounts, :members, :users)

  def test_validation_at_signin_attempt_as_owner_with_invalid_email
    account = account_with_schema(:playing_piano)
    within_subdomain(account.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => account.subdomain)
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

  def test_validation_at_signin_attempt_as_owner_with_invalid_password
    account = account_with_schema(:playing_piano)
    within_subdomain(account.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => account.subdomain)
      click_button("Continue")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Please signin.")
      fill_in("Email",   :with => account.owners.first.email)
      fill_in("Password",:with => "invalid")
      click_button("Signin")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Email or password is invalid.")
      logout_user(locker_room.logout_url, :delete)
    end
  end

  def test_validation_at_signin_attempt_as_owner_with_other_subdomain
    account       = account_with_schema(:penguin_patrol)
    other_account = account_with_schema(:playing_piano)
    within_subdomain(other_account.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => other_account.subdomain)
      click_button("Continue")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Please signin.")
      fill_in("Email",   :with => account.owners.first.email)
      fill_in("Password",:with => "secret")
      click_button("Signin")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Email or password is invalid.")
      logout_user(locker_room.logout_url, :delete)
    end
  end

  def test_signin_as_owner
    account = account_with_schema(:playing_piano)
    within_subdomain(account.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => account.subdomain)
      click_button("Continue")
      assert_equal(locker_room.login_url, page.current_url)
      assert_content("Please signin.")
      fill_in("Email",   :with => account.owners.first.email)
      fill_in("Password",:with => "secret")
      click_button("Signin")
      assert_equal(locker_room.root_url, page.current_url)
      assert_content("You are now signed in.")
      logout_user(locker_room.logout_url, :delete)
    end
  end

  def test_validation_at_signin_attempt_as_member_with_invalid_email
    user = user_with_schema(:weenie)
    within_subdomain(user.account.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => user.account.subdomain)
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

  def test_validation_at_signin_attempt_as_member_with_invalid_password
    user = user_with_schema(:weenie)
    within_subdomain(user.account.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => user.account.subdomain)
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

  def test_signin_as_member
    user = user_with_schema(:weenie)
    within_subdomain(user.account.subdomain) do
      visit(locker_room.login_url(:subdomain => nil))
      assert_equal(locker_room.login_url(:subdomain => nil), page.current_url)
      fill_in("Subdomain", :with => user.account.subdomain)
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
