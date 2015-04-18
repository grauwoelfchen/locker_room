require "test_helper"

class UserSigninTest < Capybara::Rails::TestCase
  include SubdomainHelpers

  fixtures("locker_room/accounts", "locker_room/members", "locker_room/users")

  def test_user_signin_as_account_owner_attempt_with_invalid_email
    account = locker_room_accounts(:playing_piano)
    login_url = locker_room.login_url(:subdomain => account.subdomain)

    visit(locker_room.root_url(:subdomain => account.subdomain))
    assert_content("Please signin.")
    assert_equal(login_url, page.current_url)
    fill_in("Email",   :with => "henry@example.org")
    fill_in("Password",:with => "ohmygosh")
    click_button("Signin")
    assert_content("Email or password is invalid.")
    assert_equal(login_url, page.current_url)
  end

  def test_user_signin_as_account_owner_attempt_with_invalid_password
    account = locker_room_accounts(:playing_piano)
    login_url = locker_room.login_url(:subdomain => account.subdomain)

    visit(locker_room.root_url(:subdomain => account.subdomain))
    assert_content("Please signin.")
    assert_equal(login_url, page.current_url)
    fill_in("Email",   :with => account.owner.email)
    fill_in("Password",:with => "weenie-girl")
    click_button("Signin")
    assert_content("Email or password is invalid.")
    assert_equal(login_url, page.current_url)
  end

  def test_user_signin_as_account_owner_attempt_with_other_subdomain
    account       = locker_room_accounts(:penguin_patrol)
    other_account = locker_room_accounts(:playing_piano)
    login_url = locker_room.login_url(:subdomain => other_account.subdomain)

    visit(locker_room.root_url(:subdomain => other_account.subdomain))
    assert_content("Please signin.")
    assert_equal(login_url, page.current_url)
    fill_in("Email",   :with => account.owner.email)
    fill_in("Password",:with => "nomorenoless")
    click_button("Signin")
    assert_content("Email or password is invalid.")
    assert_equal(login_url, page.current_url)
  end

  def test_user_signin_as_account_owner
    account = locker_room_accounts(:playing_piano)
    root_url  = locker_room.root_url(:subdomain => account.subdomain)
    login_url = locker_room.login_url(:subdomain => account.subdomain)

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

  def test_user_signin_as_member_attempt_with_invalid_email
    user    = locker_room_users(:weenie)
    account = user.accounts.first
    login_url = locker_room.login_url(:subdomain => account.subdomain)

    visit(locker_room.root_url(:subdomain => account.subdomain))
    assert_content("Please signin.")
    assert_equal(login_url, page.current_url)
    fill_in("Email",   :with => "henry@example.org")
    fill_in("Password",:with => "bowwow")
    click_button("Signin")
    assert_content("Email or password is invalid.")
    assert_equal(login_url, page.current_url)
  end

  def test_user_signin_as_member_attempt_with_invalid_password
    user    = locker_room_users(:weenie)
    account = user.accounts.first
    login_url = locker_room.login_url(:subdomain => account.subdomain)

    visit(locker_room.root_url(:subdomain => account.subdomain))
    assert_content("Please signin.")
    assert_equal(login_url, page.current_url)
    fill_in("Email",   :with => user.email)
    fill_in("Password",:with => "woof")
    click_button("Signin")
    assert_content("Email or password is invalid.")
    assert_equal(login_url, page.current_url)
  end

  def test_user_signin_as_member
    user    = locker_room_users(:weenie)
    account = user.accounts.first
    root_url  = locker_room.root_url(:subdomain => account.subdomain)
    login_url = locker_room.login_url(:subdomain => account.subdomain)

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
