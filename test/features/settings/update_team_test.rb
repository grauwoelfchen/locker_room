require 'test_helper'

class SettingsUpdateTeamTest < Capybara::Rails::TestCase
  locker_room_fixtures(:teams, :users, :mateships, :types)

  def setup
    @team = team_with_schema(:playing_piano)
  end

  def teardown
    logout_user(nil, :delete)
  end

  def test_updating_team_settings_as_user
    login_user(@team.members.first, @team.subdomain)
    within_subdomain(@team.subdomain) do
      visit(locker_room.team_settings_url)
      assert_content('You are not allowed to do that.')
    end
  end

  def test_updating_team_settings_as_owner_with_invaild_attributes_fails
    login_user(@team.primary_owner, @team.subdomain)
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Team Settings')
      fill_in('Name', :with => '')
      click_button('Update Team')
      assert_content('Name can\'t be blank')
      assert_content('Team could not be updated.')
      @team.reload
      assert_not_equal(@team.name, 'New name')
    end
  end

  def test_updating_a_team_s_name_as_owner
    login_user(@team.primary_owner, @team.subdomain)
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Team Settings')
      fill_in('Name', :with => 'New name')
      click_button('Update Team')
      assert_content('Team has been updated successfully.')
      assert_equal(locker_room.team_settings_url, page.current_url)
      @team.reload
      assert_equal(@team.name, 'New name')
    end
  end

  def test_updating_a_team_s_type_with_invalid_credit_card_number_fails
    extreme_type = locker_room_types(:extreme_type)
    @team.update_columns(:type_id => nil, :subscription_id => nil)
    @team.reload
    # errors
    # see:
    #   https://github.com/highfidelity/fake_braintree/
    #   blob/master/lib/fake_braintree.rb#L46
    FakeBraintree.registry.failures = {
      'invalid' => {
        'message' => 'Credit card number must be 12-19 digits'
      }
    }
    login_user(@team.primary_owner, @team.subdomain)
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Team Settings')
      select('Extreme', :from => 'Type')
      click_button('Update Team')
      # at type
      assert_equal(
        locker_room.team_type_settings_url(:type_id => extreme_type.id),
        page.current_url
      )
      assert_content('You are changing to the \'Extreme\' type')
      assert_content('This type costs $18.0 per month')
      # at type form
      fill_in('Credit card number', :with => 'invalid')
      fill_in('Name on card', :with => 'OSWALD')
      now = Time.now
      future_date = "#{now.month + 1}/#{now.year + 1}"
      fill_in('Expiration date', :with => future_date)
      fill_in('CVV', :with => '123')
      click_button('Change type')
      # at subscribe
      assert_content('Invalid credit card details. Please try again.')
      assert_content('Credit card number must be 12-19 digits')
    end
  end

  def test_updating_a_team_s_type_as_owner
    starter_type = locker_room_types(:starter_type)
    extreme_type = locker_room_types(:extreme_type)
    @team.update_columns(:type_id => nil, :subscription_id => nil)
    @team.reload
    Braintree::Subscription.any_instance
      .expects(:id)
      .returns('foo123')
    login_user(@team.primary_owner, @team.subdomain)
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Team Settings')
      select('Extreme', :from => 'Type')
      click_button('Update Team')
      # at type
      assert_equal(
        locker_room.team_type_settings_url(:type_id => extreme_type.id),
        page.current_url
      )
      assert_content('You are changing to the \'Extreme\' type')
      assert_content('This type costs $18.0 per month')
      # at type form
      fill_in('Credit card number', :with => '1111111111111')
      fill_in('Name on card', :with => 'OSWALD')
      now = Time.now
      future_date = "#{now.month + 1}/#{now.year + 1}"
      fill_in('Expiration date', :with => future_date)
      fill_in('CVV', :with => '666')
      click_button('Change type')
      # at root
      assert_content('Your team is now on the \'Extreme\' type.')
      assert_equal(locker_room.team_settings_url, page.current_url)
      @team.reload
      assert_equal(@team.type, extreme_type)
      assert_equal(@team.subscription_id, 'foo123')
    end
  end

  def test_changing_type_after_initial_subscription_fails
    starter_type = locker_room_types(:starter_type)
    extreme_type = locker_room_types(:extreme_type)
    # no registered previous subscription
    login_user(@team.primary_owner, @team.subdomain)
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Team Settings')
      select('Extreme', :from => 'Type')
      click_button('Update Team')
      # at type
      assert_equal(
        locker_room.team_type_settings_url(:type_id => extreme_type.id),
        page.current_url
      )
      assert_content('You are changing to the \'Extreme\' type')
      assert_content('This type costs $18.0 per month')
      # at type form
      click_button('Change type')
      # at root
      assert_content('Something went wrong. Please try again.')
      assert_equal(
        locker_room.team_type_settings_url(:type_id => extreme_type.id),
        page.current_url
      )
      @team.reload
      assert_not_equal(@team.type, extreme_type)
    end
  end

  def test_changing_type_after_initial_subscription
    starter_type = locker_room_types(:starter_type)
    extreme_type = locker_room_types(:extreme_type)
    # register previous subscription
    subscription_id = @team.subscription_id
    subscription = FakeBraintree::Subscription.new(
      {}, {:id => subscription_id})
    subscription_result = subscription.create
    login_user(@team.primary_owner, @team.subdomain)
    within_subdomain(@team.subdomain) do
      visit(locker_room.root_url)
      assert_equal(locker_room.root_url, page.current_url)
      click_link('Team Settings')
      select('Extreme', :from => 'Type')
      click_button('Update Team')
      # at type
      assert_equal(
        locker_room.team_type_settings_url(:type_id => extreme_type.id),
        page.current_url
      )
      assert_content('You are changing to the \'Extreme\' type')
      assert_content('This type costs $18.0 per month')
      # at type form
      click_button('Change type')
      # at root
      assert_content('Your team has switched to the \'Extreme\' type.')
      assert_equal(locker_room.team_settings_url, page.current_url)
      @team.reload
      assert_equal(@team.type, extreme_type)
      assert_equal(@team.subscription_id, subscription_id)
    end
  end
end
