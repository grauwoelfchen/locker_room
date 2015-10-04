require 'test_helper'

class TeamsUpdatingTest < Capybara::Rails::TestCase
  locker_room_fixtures(:teams, :users, :mateships, :plans)

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

  def test_updating_a_team_s_plan_as_owner
    starter_plan = locker_room_plans(:starter_plan)
    extreme_plan = locker_room_plans(:extreme_plan)
    login_user(@team.primary_owner)
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Edit Team')
      select('Extreme', :from => 'Plan')
      click_button('Update Team')
      # at plan
      plan_url = locker_room.plan_team_url(:plan_id => extreme_plan.id)
      assert_equal(plan_url, page.current_url)
      assert_content('Team has been updated successfully.')
      assert_content('You are changing to the \'Extreme\' plan')
      assert_content('This plan costs $18.0 per month')
      # at plan form
      fill_in('Credit card number', :with => '1111111111111')
      fill_in('Name on card', :with => 'OSWALD')
      now = Time.now
      future_date = "#{now.month + 1}/#{now.year + 1}"
      fill_in('Expiration date', :with => future_date)
      fill_in('CVV', :with => '123')
      click_button('Change plan')
      # at root
      assert_content('Your team is now on the \'Extreme\' plan.')
      assert_equal(locker_room.root_url, page.current_url)
    end
  end

  def test_change_team_s_plan_with_invalid_credit_card_number_fails
    extreme_plan = locker_room_plans(:extreme_plan)
    # errors
    # see:
    #   https://github.com/highfidelity/fake_braintree/
    #   blob/master/lib/fake_braintree.rb#L46
    FakeBraintree.registry.failures = {
      'invalid' => {
        'message' => 'Credit card number must be 12-19 digits'
      }
    }
    login_user(@team.primary_owner)
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Edit Team')
      select('Extreme', :from => 'Plan')
      click_button('Update Team')
      # at plan
      plan_url = locker_room.plan_team_url(:plan_id => extreme_plan.id)
      assert_equal(plan_url, page.current_url)
      assert_content('Team has been updated successfully.')
      assert_content('You are changing to the \'Extreme\' plan')
      assert_content('This plan costs $18.0 per month')
      # at plan form
      fill_in('Credit card number', :with => 'invalid')
      fill_in('Name on card', :with => 'OSWALD')
      now = Time.now
      future_date = "#{now.month + 1}/#{now.year + 1}"
      fill_in('Expiration date', :with => future_date)
      fill_in('CVV', :with => '123')
      click_button('Change plan')
      # at subscribe
      assert_content('Invalid credit card details. Please try again.')
      assert_content('Credit card number must be 12-19 digits')
    end
  end
end
