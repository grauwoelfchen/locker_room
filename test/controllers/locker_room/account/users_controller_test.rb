require 'test_helper'

module LockerRoom
  module Account
    class UsersControllerTest < ActionController::TestCase
      locker_room_fixtures(:teams, :users, :mateships)

      def test_new
        team = locker_room_teams(:playing_piano)
        within_subdomain(team.subdomain) do
          get(:new)
          refute(assigns(:user).persisted?)
          assert_kind_of(LockerRoom::User, assigns(:user))
          assert_equal(assigns(:user).mateships, [])
          assert_template(:new)
          assert_response(:success)
        end
      end

      def test_create_with_validation_error
        team = locker_room_teams(:playing_piano)
        within_subdomain(team.subdomain) do
          params = {
            :user => {
              :username              => 'daisy',
              :email                 => 'daisy@example.org',
              :name                  => 'Daisy',
              :password              => '',
              :password_confirmation => ''
            }
          }
          post(:create, params: params)
          refute(assigns(:user).persisted?)
          assert([assigns(:current_team)], assigns(:user).teams)
          assert_equal(assigns(:user).mateships, [])
          assert_kind_of(LockerRoom::User, assigns(:user))
          assert_template(:new)
          assert_response(:success)
        end
      end
    end
  end
end
