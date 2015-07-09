require 'test_helper'

module LockerRoom
  class TeamsControllerTest < ActionController::TestCase
    locker_room_fixtures(:teams, :users, :memberships)

    def test_create_with_validation_errors
      params = {
        :team => {
          :name      => "Unicycle",
          :subdomain => "",
          :owners_attributes => {
            "0" => {
              :email                 => "daisy@example.org",
              :password              => "hellyhollyhally",
              :password_confirmation => "hellyhollyhally"
            }
          }
        }
      }
      expression = %w(
        LockerRoom::Team.count
        LockerRoom::User.count
        LockerRoom::Membership.count
      )
      assert_no_difference(expression, 1) do
        post(:create, params)
      end
      assert_instance_of(LockerRoom::Team, assigns(:team))
      refute(assigns(:team).persisted?)
      assert_equal(flash[:alert], "Your team could not be created.")
      assert_nil(flash[:notice])
      assert_template(:new)
      assert_template(:partial => "locker_room/shared/_errors")
      assert_template(:partial => "locker_room/member/users/_form")
      assert_response(:success)
    end

    def test_create
      @controller.stub(:login, true) do
        user = Minitest::Mock.new
        user.expect(:email, "daisy@example.org")
        team = Minitest::Mock.new
        team.expect(:create_schema, true)
        team.expect(:created?, true)
        team.expect(:owners, [user])
        team.expect(:subdomain, "unicycle")
        LockerRoom::Team.stub(:create_with_owner, team) do
          params = {
            :team => {
              :name => "Unicycle",
            }
          }
          post(:create, params)
          team.verify
        end
        assert_response(:redirect)
        assert_redirected_to(root_url(:subdomain => "unicycle"))
      end
    end
  end
end
