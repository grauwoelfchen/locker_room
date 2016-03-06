require 'test_helper'

module LockerRoom
  module Settings
    class PasswordsControllerTest < ActionController::TestCase
      locker_room_fixtures(:teams, :users, :mateships)

      def test_get_edit
        user = locker_room_users(:oswald)
        team = user.teams.first!
        login_user(user)
        within_subdomain(team.subdomain) do
          get(:edit)
          assert(assigns(:user).persisted?)
          assert_template(:edit)
          assert_response(:success)
        end
        logout_user
      end

      def test_put_update
        user = locker_room_users(:oswald)
        team = user.teams.first!
        login_user(user)
        within_subdomain(team.subdomain) do
          params = {
            user: {
              current_password:      'secret',
              password:              'newsecret',
              password_confirmation: 'newsecret'
            }
          }
          put(:update, params)
          assert(assigns(:user).persisted?)
          assert_empty(assigns[:user].errors)
          message = 'Password has been updated successfully.'
          assert_equal(message, flash[:notice])
          assert_response(:redirect)
          assert_redirected_to(password_settings_url)
        end
        logout_user
      end
    end
  end
end
