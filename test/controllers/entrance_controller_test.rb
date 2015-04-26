require 'test_helper'

module LockerRoom
  class EntranceControllerTest < ActionController::TestCase
    def test_index
      get(:index)
      assert_template(:index)
      assert_response(:success)
    end
  end
end
