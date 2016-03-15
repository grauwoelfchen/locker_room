require 'test_helper'

module LockerRoom
  class RoutesTest < ActionDispatch::IntegrationTest
    locker_room_fixtures(:teams, :users, :mateships)

    setup(:set_routes)

    def test_route_to_recovery_passwords
      within_subdomain_host do |host|
        assert_routing({
          :method => 'get',
          :path   => "#{host}/recovery/password"
        }, {
          :controller => 'locker_room/recovery/passwords',
          :action     => 'new'
        })

        assert_routing({
          :method => 'post',
          :path   => "#{host}/recovery/password"
        }, {
          :controller => 'locker_room/recovery/passwords',
          :action     => 'create'
        })

        assert_routing({
          :method => 'get',
          :path   => "#{host}/recovery/password/token"
        }, {
          :controller => 'locker_room/recovery/passwords',
          :action     => 'edit',
          :token      => 'token'
        })
        assert_raises(Minitest::Assertion) do
          assert_routing({
            :method => 'get',
            :path   => "#{host}/recovery/password/token-123"
          }, {
            :controller => 'locker_room/recovery/passwords',
            :action     => 'edit',
            :token      => 'token-123'
          })
        end

        assert_routing({
          :method => 'put',
          :path   => "#{host}/recovery/password/token"
        }, {
          :controller => 'locker_room/recovery/passwords',
          :action     => 'update',
          :token      => 'token'
        })
        assert_routing({
          :method => 'patch',
          :path   => "#{host}/recovery/password/token"
        }, {
          :controller => 'locker_room/recovery/passwords',
          :action     => 'update',
          :token      => 'token'
        })
      end
    end

    private

    def set_routes
      @routes = LockerRoom::Engine.routes
    end

    def within_subdomain_host
      user = locker_room_users(:oswald)
      team = user.teams.first!
      host = "http://#{team.subdomain}.#{ENV['TEST_HOST']}"
      yield(host)
    end
  end
end
