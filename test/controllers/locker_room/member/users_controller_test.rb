require 'test_helper'

module LockerRoom
  module Member
    class UsersControllerTest < ActionController::TestCase
      locker_room_fixtures(:teams, :users, :memberships)

      def test_new
        get(:new)
        refute(assigns(:user).persisted?)
        refute(assigns(:user).membership.persisted?)
        assert_kind_of(LockerRoom::User, assigns(:user))
        assert_kind_of(LockerRoom::Membership, assigns(:user).membership)
        assert_template(:new)
        assert_response(:success)
      end

      def test_create_with_validation_error
        team = locker_room_teams(:playing_piano)
        within_subdomain(team.subdomain) do
          params = {
            :user => {
              :email                 => "daisy@example.org",
              :password              => "",
              :password_confirmation => "",
              :membership_attributes => {
                :name     => "Daisy",
                :username => "daisy"
              }
            }
          }
          post(:create, params)
          refute(assigns(:user).persisted?)
          refute(assigns(:user).membership.persisted?)
          assert(assigns(:current_team), assigns(:user).membership.team)
          assert_kind_of(LockerRoom::User, assigns(:user))
          assert_kind_of(LockerRoom::Membership, assigns(:user).membership)
          assert_template(:new)
          assert_response(:success)
        end
      end
    end
  end
end
