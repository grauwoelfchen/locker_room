class CreateLockerRoomTeams < ActiveRecord::Migration
  def change
    create_table :locker_room_teams do |t|
      t.string  :name
      t.string  :subdomain

      t.timestamps null: false
    end

    add_index :locker_room_teams, :subdomain
  end
end
