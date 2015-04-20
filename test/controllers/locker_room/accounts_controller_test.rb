require 'test_helper'

module LockerRoom
  class AccountsControllerTest < ActionController::TestCase
    locker_room_fixtures(:accounts, :members, :users)

    def test_create_with_validation_errors
      params = {
        :account => {
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
        LockerRoom::Account.count
        LockerRoom::User.count
        LockerRoom::Member.count
      )
      assert_no_difference(expression, 1) do
        post(:create, params)
      end
      assert_instance_of(LockerRoom::Account, assigns(:account))
      refute(assigns(:account).persisted?)
      assert_equal(flash[:alert], "Your account could not be created.")
      assert_nil(flash[:notice])
      assert_template(:new)
      assert_template(:partial => "locker_room/shared/_errors")
      assert_template(:partial => "locker_room/account/users/_form")
      assert_response(:success)
    end

    def test_create
      @controller.stub(:login, true) do
        user = Minitest::Mock.new
        user.expect(:email, "daisy@example.org")
        account = Minitest::Mock.new
        account.expect(:valid?, true)
        account.expect(:owners, [user])
        account.expect(:subdomain, "unicycle")
        LockerRoom::Account.stub(:create_with_owner, account) do
          params = {
            :account => {
              :name => "Unicycle",
            }
          }
          post(:create, params)
          account.verify
        end
        assert_response(:redirect)
        assert_redirected_to(root_url(:subdomain => "unicycle"))
      end
    end
  end
end
