require "test_helper"

class AccountSigninTest < Capybara::Rails::TestCase
  locker_room_fixtures(:accounts)

  def test_account_not_found
    visit(locker_room.login_url(:subdomain => nil))
    assert_equal("http://example.org/login", page.current_url)
    fill_in("Subdomain", :with => "www")
    click_button("Continue")
    assert_equal("http://example.org/login", page.current_url)
    assert_content("Account is not found.")
  end

  def test_account_signin
    visit(locker_room.login_url(:subdomain => nil))
    assert_equal("http://example.org/login", page.current_url)
    account = locker_room_accounts(:playing_piano)
    account.create_schema
    fill_in("Subdomain", :with => account.subdomain)
    click_button("Continue")
    login_url = "http://#{account.subdomain}.example.org/login"
    assert_equal(login_url, page.current_url)
    assert_content("Please signin.")
  end
end
