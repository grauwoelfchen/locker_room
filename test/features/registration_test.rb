require 'test_helper'

class RegistrationTest < Capybara::Rails::TestCase
  locker_room_fixtures(:teams, :users, :mateships, :types)

  def test_subdomain_uniqueness_ensuring
    penguin = locker_room_teams(:penguin_patrol)
    visit(locker_room.root_url)
    click_link('Create your team')
    find('input[id=team_name]').set('Vanilla dog biscuits')
    fill_in('Subdomain', :with => penguin.subdomain)
    fill_in('Username',  :with => 'weenie')
    find('input[id=team_owners_attributes_0_name]').set('Weenie')
    fill_in('Email',                 :with => 'oswald@example.com')
    fill_in('Password',              :with => 'ohmygosh', :exact => true)
    fill_in('Password confirmation', :with => 'ohmygosh')
    click_button('Create Team')
    assert_equal('http://example.org/signup', page.current_url)
    assert_content('Team could not be created.')
    assert_content('Subdomain has already been taken')
  end

  def test_subdomain_restriction_with_reserved_word
    visit(locker_room.root_url)
    click_link('Create your team')
    find('input[id=team_name]').set('Vanilla dog biscuits')
    fill_in('Subdomain', :with => 'admin')
    fill_in('Username',  :with => 'weenie')
    find('input[id=team_owners_attributes_0_name]').set('Weenie')
    fill_in('Email',                 :with => 'weenie@example.com')
    fill_in('Password',              :with => 'bowwow', :exact => true)
    fill_in('Password confirmation', :with => 'bowwow')
    click_button('Create Team')
    assert_equal('http://example.org/signup', page.current_url)
    assert_content('Team could not be created.')
    assert_content('Subdomain admin is not allowed')
  end

  def test_subdomain_restriction_with_invalid_word
    visit(locker_room.root_url)
    click_link('Create your team')
    find('input[id=team_name]').set('Vanilla dog biscuits')
    fill_in('Subdomain', :with => '<test>')
    fill_in('Username',  :with => 'weenie')
    find('input[id=team_owners_attributes_0_name]').set('Weenie')
    fill_in('Email',                 :with => 'weenie@example.com')
    fill_in('Password',              :with => 'bowwow', :exact => true)
    fill_in('Password confirmation', :with => 'bowwow')
    click_button('Create Team')
    assert_equal('http://example.org/signup', page.current_url)
    assert_content('Team could not be created.')
    assert_content('Subdomain <test> is not allowed')
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

  def test_team_registration
    visit(locker_room.root_url)
    click_link('Create your team')
    find('input[id=team_name]').set('Lovely flowers')
    fill_in('Subdomain', :with => 'lovely-flowers')
    fill_in('Username',  :with => 'daisy')
    find('input[id=team_owners_attributes_0_name]').set('Daisy')
    fill_in('Email',                 :with => 'daisy@example.org')
    fill_in('Password',              :with => 'byebyuuun', :exact => true)
    fill_in('Password confirmation', :with => 'byebyuuun')
    click_button('Create Team')
    assert_equal('http://lovely-flowers.example.org/', page.current_url)
    assert_content('Team has been successfully created.')
    assert_content('Signed in as daisy@example.org')
    logout_user
  end
end
