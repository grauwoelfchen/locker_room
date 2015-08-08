require 'test_helper'

module LockerRoom
  module Member
    class UsersControllerTest < ActionController::TestCase
      locker_room_fixtures(:teams, :users, :mateships)

      def test_new
        get(:new)
        refute(assigns(:user).persisted?)
        refute(assigns(:user).mateship.persisted?)
        assert_kind_of(LockerRoom::User, assigns(:user))
        assert_kind_of(LockerRoom::Mateship, assigns(:user).mateship)
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
              :mateship_attributes   => {
                :name     => "Daisy",
                :username => "daisy"
              }
            }
          }
          post(:create, params)
          refute(assigns(:user).persisted?)
          refute(assigns(:user).mateship.persisted?)
          assert(assigns(:current_team), assigns(:user).mateship.team)
          assert_kind_of(LockerRoom::User, assigns(:user))
          assert_kind_of(LockerRoom::Mateship, assigns(:user).mateship)
          assert_template(:new)
          assert_response(:success)
        end
      end
    end
  end
end
