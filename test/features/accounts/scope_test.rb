require "test_helper"

class AccountScopTest < Capybara::Rails::TestCase
  fixtures("locker_room/accounts", "locker_room/members", "locker_room/users")

  def setup
    @account_piano   = locker_room_accounts(:playing_piano)
    @account_penguin = locker_room_accounts(:penguin_patrol)
    Talk.scoped_to(@account_piano).create(:theme => "Musical instrument")
    Talk.scoped_to(@account_penguin).create(:theme => "The ice")
  end

  def test_scoped_visibility_for_account_piano
    login_user(@account_piano.owners.first)
    visit(main_app.talks_url(:subdomain => @account_piano.subdomain))
    assert_content("Musical instrument")
    refute_content("The ice")
  end

  def test_scoped_visibility_for_account_penguin
    login_user(@account_penguin.owners.first)
    visit(main_app.talks_url(:subdomain => @account_penguin.subdomain))
    refute_content("Musical instrument")
    assert_content("The ice")
  end
end
