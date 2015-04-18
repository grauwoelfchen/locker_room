require "test_helper"

class UserSigninTest < Capybara::Rails::TestCase
  include SubdomainHelpers

  fixtures("locker_room/accounts", "locker_room/members", "locker_room/users")

  def test_user_signin_as_account_owner
    account = locker_room_accounts(:playing_piano)

    root_url  = "http://#{account.subdomain}.example.org/"
    login_url = "http://#{account.subdomain}.example.org/login"

    within_account_subdomain(account.subdomain) do
      visit(root_url)
      assert_equal(login_url, page.current_url)
      fill_in("Email",   :with => account.owner.email)
      fill_in("Password",:with => "ohmygosh")
      click_button("Signin")
      assert_content("You are now signed in.")
      assert_equal(root_url, page.current_url)
    end
  end

  def test_user_signin_as_member
    user = locker_room_users(:weenie)
    account = user.accounts.first

    root_url  = "http://#{account.subdomain}.example.org/"
    login_url = "http://#{account.subdomain}.example.org/login"

    within_account_subdomain(account.subdomain) do
      visit(root_url)
      assert_equal(login_url, page.current_url)
      fill_in("Email",   :with => user.email)
      fill_in("Password",:with => "bowwow")
      click_button("Signin")
      assert_content("You are now signed in.")
      assert_equal(root_url, page.current_url)
    end
  end
end
