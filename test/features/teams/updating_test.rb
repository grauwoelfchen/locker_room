require 'test_helper'

class TeamsUpdatingTest < Capybara::Rails::TestCase
  locker_room_fixtures(:teams, :users, :mateships)

  def setup
    @team = team_with_schema(:playing_piano)
  end

  def teardown
    logout_user
  end

  def test_updating_a_team_as_user
    login_user(@team.members.first)
    within_subdomain(@team.subdomain) do
      visit(locker_room.edit_team_url)
      assert_content('You are not allowed to do that.')
    end
  end

  def test_updating_a_team_as_owner_with_invaild_attributes_fails
    login_user(@team.primary_owner)
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Edit Team')
      fill_in('Name', :with => '')
      click_button('Update Team')
      assert_content('Name can\'t be blank')
      assert_content('Team could not be updated.')
      @team.reload
      assert_not_equal(@team.name, 'New name')
    end
  end

  def test_updating_a_team_as_owner
    login_user(@team.primary_owner)
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Edit Team')
      fill_in('Name', :with => 'New name')
      click_button('Update Team')
      assert_content('Team has been updated successfully.')
      assert_equal(locker_room.root_url, page.current_url)
      @team.reload
      assert_equal(@team.name, 'New name')
    end
  end
end
