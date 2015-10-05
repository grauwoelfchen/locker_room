class AddSubscriptionIdToLockerRoomTeams < ActiveRecord::Migration
  def change
    add_column :locker_room_teams, :subscription_id, :string
  end
end
