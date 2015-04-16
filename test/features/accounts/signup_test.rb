require "test_helper"

class SignupTest < Capybara::Rails::TestCase
  def test_account_creation
    visit(locker_room.root_path)
    click_link("Account Signup")
    fill_in("Name",                  :with => "Vanilla dog biscuits")
    fill_in("Subdomain",             :with => "vanilla-dog-biscuits")
    fill_in("Email",                 :with => "weenie@example.org")
    fill_in("Password",              :with => "bowwow", :exact => true)
    fill_in("Password confirmation", :with => "bowwow")
    click_button("Create Account")
    assert_equal("http://example.org/", page.current_url)
    assert_content("Signed in as weenie@example.org")
    assert_content("Your account has been successfully created.")
  end
end
