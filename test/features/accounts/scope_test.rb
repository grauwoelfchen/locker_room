require "test_helper"

class AccountScopTest < Capybara::Rails::TestCase
  locker_room_fixtures(:accounts, :members, :users)

  def setup
    @account_piano   = account_with_schema(:playing_piano)
    @account_penguin = account_with_schema(:penguin_patrol)

    Apartment::Tenant.switch!(@account_piano.subdomain)
    Talk.create(:theme => "Musical instrument")
    Apartment::Tenant.switch!(@account_penguin.subdomain)
    Talk.create(:theme => "The ice")
    Apartment::Tenant.reset
  end

  def teardown
    logout_user
  end

  def test_scoped_visibility_for_account_piano
    user = @account_piano.owners.first
    login_user(user)
    visit(main_app.talks_url(:subdomain => @account_piano.subdomain))
    assert_content("Musical instrument")
    refute_content("The ice")
  end

  def test_scoped_visibility_for_account_penguin
    user = @account_penguin.owners.first
    login_user(user)
    visit(main_app.talks_url(:subdomain => @account_penguin.subdomain))
    refute_content("Musical instrument")
    assert_content("The ice")
  end
end
