class AddPlanIdToLockerRoomTeams < ActiveRecord::Migration
  def change
    add_column :locker_room_teams, :plan_id, :integer
  end
end
