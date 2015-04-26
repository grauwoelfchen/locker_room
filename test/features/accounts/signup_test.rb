require "test_helper"

class AccountSignupTest < Capybara::Rails::TestCase
  locker_room_fixtures(:accounts, :members, :users)

  def test_subdomain_uniqueness_ensuring
    penguin = locker_room_accounts(:penguin_patrol)

    visit(locker_room.root_url)
    click_link("Account Signup")
    fill_in("Name",                  :with => "Penguin Octupus Patrol")
    fill_in("Subdomain",             :with => "penguin")
    fill_in("Email",                 :with => "oswald@example.com")
    fill_in("Password",              :with => "ohmygosh", :exact => true)
    fill_in("Password confirmation", :with => "ohmygosh")
    click_button("Create Account")
    assert_equal("http://example.org/signup", page.current_url)
    assert_content("Your account could not be created.")
    assert_content("Subdomain has already been taken")
  end

  def test_subdomain_restriction_with_reserved_word
    visit(locker_room.root_url)
    click_link("Account Signup")
    fill_in("Name",                  :with => "Vanilla dog biscuits")
    fill_in("Subdomain",             :with => "admin")
    fill_in("Email",                 :with => "weenie@example.com")
    fill_in("Password",              :with => "bowwow", :exact => true)
    fill_in("Password confirmation", :with => "bowwow")
    click_button("Create Account")
    assert_equal("http://example.org/signup", page.current_url)
    assert_content("Your account could not be created.")
    assert_content("Subdomain admin is not allowed")
  end

  def test_subdomain_restriction_with_invalid_word
    visit(locker_room.root_url)
    click_link("Account Signup")
    fill_in("Name",                  :with => "Vanilla dog biscuits")
    fill_in("Subdomain",             :with => "<test>")
    fill_in("Email",                 :with => "weenie@example.com")
    fill_in("Password",              :with => "bowwow", :exact => true)
    fill_in("Password confirmation", :with => "bowwow")
    click_button("Create Account")
    assert_equal("http://example.org/signup", page.current_url)
    assert_content("Your account could not be created.")
    assert_content("Subdomain <test> is not allowed")
  end

  def test_validation_with_duplicated_email
    # TODO
  end

  def test_validation_with_invalid_email
    # TODO
  end

  def test_validation_with_too_short_password
    # TODO
  end

  def test_validation_with_invalid_password
    # TODO
  end

  def test_validation_with_unmatch_password
    # TODO
  end

  def test_account_signup
    visit(locker_room.root_url)
    click_link("Account Signup")
    fill_in("Name",                  :with => "Vanilla dog biscuits")
    fill_in("Subdomain",             :with => "vanilla-dog-biscuits")
    fill_in("Email",                 :with => "weenie@example.com")
    fill_in("Password",              :with => "bowwow", :exact => true)
    fill_in("Password confirmation", :with => "bowwow")
    click_button("Create Account")
    assert_equal("http://vanilla-dog-biscuits.example.org/", page.current_url)
    assert_content("Your account has been successfully created.")
    assert_content("Signed in as weenie@example.com")
    logout_user
  end
end
