require 'test_helper'

class SettingsUpdateUserTest < Capybara::Rails::TestCase
  locker_room_fixtures(:teams, :users, :mateships, :types)

  def setup
    @user = user_with_schema(:oswald)
    @team = @user.teams.first
    login_user(@user, @team.subdomain)
  end

  def teardown
    logout_user(nil, :delete)
  end

  def test_updating_user_settings_with_invaild_attributes_fails
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Account Settings')
      assert_equal(locker_room.user_settings_url, page.current_url)
      fill_in('Username', :with => 'henry')
      click_button('Update Account')
      assert_equal(locker_room.user_settings_url, page.current_url)
      assert_content('Username has already been taken')
      assert_content('Account could not be updated.')
      @user.reload
      assert_not_equal(@user.username, 'henry')
    end
  end

  def test_updating_user_settings_with_invalid_password_fails
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Account Settings')
      assert_equal(locker_room.user_settings_url, page.current_url)
      fill_in('user_password',              :with => 'iwillbepenguin')
      fill_in('user_password_confirmation', :with => 'iamnotapenguin')
      click_button('Update Account')
      assert_equal(locker_room.user_settings_url, page.current_url)
      assert_content('Password confirmation doesn\'t match Password')
    end
  end

  def test_updating_user_settings
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Account Settings')
      assert_equal(locker_room.user_settings_url, page.current_url)
      fill_in('Name', :with => 'Oswald the Penguin')
      click_button('Update Account')
      assert_equal(locker_room.root_url, page.current_url)
      assert_content('Account has been updated successfully.')
      @user.reload
      assert_equal(@user.name, 'Oswald the Penguin')
    end
  end
end
