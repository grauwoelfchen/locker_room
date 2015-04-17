require "test_helper"

class SignupTest < Capybara::Rails::TestCase
  fixtures("locker_room/accounts", "locker_room/members", "locker_room/users")

  def test_account_creation
    visit(locker_room.root_path)
    click_link("Account Signup")
    fill_in("Name",                  :with => "Vanilla dog biscuits")
    fill_in("Subdomain",             :with => "vanilla-dog-biscuits")
    fill_in("Email",                 :with => "weenie@example.org")
    fill_in("Password",              :with => "bowwow", :exact => true)
    fill_in("Password confirmation", :with => "bowwow")
    click_button("Create Account")
    assert_equal("http://vanilla-dog-biscuits.example.org/", page.current_url)
    assert_content("Your account has been successfully created.")
    assert_content("Signed in as weenie@example.org")
  end

  def test_subdomain_uniqueness_ensuring
    penguin = locker_room_accounts(:penguin_patrol)

    visit(locker_room.root_path)
    click_link("Account Signup")
    fill_in("Name",                  :with => "Penguin Octupus Patrol")
    fill_in("Subdomain",             :with => "penguin")
    fill_in("Email",                 :with => "oswald@example.org")
    fill_in("Password",              :with => "ohmygosh", :exact => true)
    fill_in("Password confirmation", :with => "ohmygosh")
    click_button("Create Account")
    assert_equal("http://example.org/accounts", page.current_url)
    assert_content("Sorry, your account could not be created.")
    assert_content("Subdomain has already been taken")
  end

  def test_subdomain_name_restriction
    visit(locker_room.root_path)
    click_link("Account Signup")
    fill_in("Name",                  :with => "Vanilla dog biscuits")
    fill_in("Subdomain",             :with => "admin")
    fill_in("Email",                 :with => "weenie@example.org")
    fill_in("Password",              :with => "bowwow", :exact => true)
    fill_in("Password confirmation", :with => "bowwow")
    click_button("Create Account")
    assert_equal("http://example.org/accounts", page.current_url)
    assert_content("Sorry, your account could not be created.")
    assert_content("Subdomain is not allowed")
  end

  def test_subdomain_name_restriction_with_invaild_name
    visit(locker_room.root_path)
    click_link("Account Signup")
    fill_in("Name",                  :with => "Vanilla dog biscuits")
    fill_in("Subdomain",             :with => "<test>")
    fill_in("Email",                 :with => "weenie@example.org")
    fill_in("Password",              :with => "bowwow", :exact => true)
    fill_in("Password confirmation", :with => "bowwow")
    click_button("Create Account")
    assert_equal("http://example.org/accounts", page.current_url)
    assert_content("Sorry, your account could not be created.")
    assert_content("Subdomain is not allowed")
  end
end
