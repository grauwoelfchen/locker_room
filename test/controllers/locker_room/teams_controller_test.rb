require 'test_helper'

module LockerRoom
  class TeamsControllerTest < ActionController::TestCase
    locker_room_fixtures(:teams, :users, :mateships)

    def test_create_with_validation_errors
      params = {
        :team => {
          :name      => 'Unicycle',
          :subdomain => '',
          :owners_attributes => {
            '0' => {
              :username              => 'daisy',
              :email                 => 'daisy@example.org',
              :password              => 'hellyhollyhally',
              :password_confirmation => 'hellyhollyhally'
            }
          }
        }
      }
      expression = %w(
        LockerRoom::Team.count
        LockerRoom::User.count
        LockerRoom::Mateship.count
      )
      assert_no_difference(expression, 1) do
        post(:create, params)
      end
      assert_instance_of(LockerRoom::Team, assigns(:team))
      refute(assigns(:team).persisted?)
      assert_equal(flash[:alert], 'Team could not be created.')
      assert_nil(flash[:notice])
      assert_template(:new)
      assert_template(:partial => 'locker_room/shared/_errors')
      assert_template(:partial => 'locker_room/account/users/_form')
      assert_response(:success)
    end

    def test_create
      @controller.stub(:user_signed_in?, true) do
        user = mock('User', id: 1)
        ownerships = mock('Ownership Relation')
        ownerships.expects(:create).returns(true)
        user.expects(:ownerships).returns(ownerships)
        team = mock('Team', subdomain: 'unicycle')
        team.expects(:primary_owner).returns(user).twice
        team.expects(:created?).returns(true)
        team.expects(:save).returns(true)
        # create_schema is called
        team.expects(:create_schema).returns(true)
        team.expects(:varid?).never
        LockerRoom::Team.expects(:new).returns(team)
        params = {
          :team => {
            :name => 'Unicycle',
          }
        }
        post(:create, params)
        assert_equal(flash[:notice], 'Team has been successfully created.')
        assert_response(:redirect)
        assert_redirected_to(root_url(:subdomain => 'unicycle'))
      end
    end
  end
end
