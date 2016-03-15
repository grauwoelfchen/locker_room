require 'test_helper'

module LockerRoom
  module Recovery
    class PasswordsControllerTest < ActionController::TestCase
      locker_room_fixtures(:teams, :users, :mateships)

      def test_get_new
        user = locker_room_users(:oswald)
        team = user.teams.first!
        within_subdomain(team.subdomain) do
          get(:new)
          assert_kind_of(LockerRoom::User, assigns[:user])
          refute(assigns[:user].persisted?)
          assert_template(:new)
          assert_response(:success)
        end
      end

      def test_post_create_with_invalid_email
        user = locker_room_users(:oswald)
        team = user.teams.first!
        within_subdomain(team.subdomain) do
          params = {
            :user => {
              :email => '#foobar'
            }
          }
          post(:create, params)
          assert_kind_of(LockerRoom::User, assigns[:user])
          refute(assigns[:user].persisted?)
          assert_nil(flash[:notice])
          assert_template(:new)
          assert_response(:success)
        end
      end

      def test_post_create_with_unknown_email
        user = locker_room_users(:oswald)
        team = user.teams.first!
        within_subdomain(team.subdomain) do
          params = {
            :user => {
              :email => 'unknown@example.org'
            }
          }
          post(:create, params)
          assert_nil(assigns[:user])
          assert_nil(flash[:notice])
          assert_response(:redirect)
          assert_redirected_to(login_url)
        end
      end

      def test_post_create
        user = locker_room_users(:oswald)
        team = user.teams.first!
        within_subdomain(team.subdomain) do
          params = {
            :user => {
              :email => user.email
            }
          }
          post(:create, params)
          assert_equal(user, assigns[:user])
          message = 'Password reset instruction has been sent.'
          assert_equal(message, flash[:notice])
          assert_response(:redirect)
          assert_redirected_to(login_url)
        end
      end

      def test_get_edit_with_unknown_token
        user = locker_room_users(:oswald)
        team = user.teams.first!
        within_subdomain(team.subdomain) do
          params = {
            :token => 'unknown'
          }
          get(:edit, params)
          assert_nil(assigns[:user])
          message = 'Token is invalid.'
          assert_equal(message, flash[:alert])
          assert_response(:redirect)
          assert_redirected_to(login_url)
        end
      end

      def test_get_edit
        user = locker_room_users(:oswald)
        params = {
          :reset_password_token            => 'token',
          :reset_password_token_expires_at => Time.now + 3.hours
        }
        user.update_columns(params)

        team = user.teams.first!
        within_subdomain(team.subdomain) do
          params = {
            :token => 'token'
          }
          get(:edit, params)
          assert_equal(user, assigns[:user])
          assert_template(:edit)
          assert_response(:success)
        end
      end

      def test_put_update_with_unknown_token
        user = locker_room_users(:oswald)
        team = user.teams.first!
        within_subdomain(team.subdomain) do
          params = {
            :token => 'unknown',
            :user  => {
              :password              => 'secure',
              :password_confirmation => 'secure'
            }
          }
          put(:update, params)
          assert_nil(assigns[:user])
          message = 'Token is invalid.'
          assert_equal(message, flash[:alert])
          assert_response(:redirect)
          assert_redirected_to(login_url)
        end
      end

      def test_put_update_with_invalid_parameters
        user = locker_room_users(:oswald)
        params = {
          :reset_password_token            => 'token',
          :reset_password_token_expires_at => Time.now + 3.hours
        }
        user.update_columns(params)

        team = user.teams.first!
        within_subdomain(team.subdomain) do
          params = {
            :token => 'token',
            :user  => {
              :password              => '???',
              :password_confirmation => 'badpassword'
            }
          }
          put(:update, params)
          assert_equal(user, assigns[:user])
          message = 'Password could not be updated.'
          assert_equal(message, flash[:alert])
          assert_nil(flash[:notice])
          assert_template(:edit)
          assert_response(:success)
        end
      end

      def test_put_update
        user = locker_room_users(:oswald)
        params = {
          :reset_password_token            => 'token',
          :reset_password_token_expires_at => Time.now + 3.hours
        }
        user.update_columns(params)

        team = user.teams.first!
        within_subdomain(team.subdomain) do
          params = {
            :token => 'token',
            :user  => {
              :password              => 'secure',
              :password_confirmation => 'secure'
            }
          }
          put(:update, params)
          assert_equal(user, assigns[:user])
          assert_nil(flash[:alert])
          message = 'Password has been updated successfully.'
          assert_equal(message, flash[:notice])
          assert_response(:redirect)
          assert_redirected_to(login_url)
        end
      end
    end
  end
end
