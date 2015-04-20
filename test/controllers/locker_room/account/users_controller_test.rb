require 'test_helper'

module LockerRoom
  class Account::UsersControllerTest < ActionController::TestCase
    locker_room_fixtures(:accounts, :members, :users)

    def test_new
      get(:new)
      refute(assigns(:user).persisted?)
      refute(assigns(:user).member.persisted?)
      assert_kind_of(LockerRoom::User, assigns(:user))
      assert_kind_of(LockerRoom::Member, assigns(:user).member)
      assert_template(:new)
      assert_response(:success)
    end

    def test_create_with_validation_error
      account = locker_room_accounts(:playing_piano)
      within_subdomain(account.subdomain) do
        params = {
          :user => {
            :email                 => "daisy@example.org",
            :password              => "",
            :password_confirmation => "",
            :member_attributes     => {
              :name     => "Daisy",
              :username => "daisy"
            }
          }
        }
        post(:create, params)
        refute(assigns(:user).persisted?)
        refute(assigns(:user).member.persisted?)
        assert(assigns(:current_account), assigns(:user).member.account)
        assert_kind_of(LockerRoom::User, assigns(:user))
        assert_kind_of(LockerRoom::Member, assigns(:user).member)
        assert_template(:new)
        assert_response(:success)
      end
    end

  end
end
