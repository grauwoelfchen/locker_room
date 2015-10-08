class CreateLockerRoomTeams < ActiveRecord::Migration
  def change
    create_table :locker_room_teams do |t|
      t.string  :name
      t.string  :subdomain
      t.integer :type_id
      t.string  :subscription_id

      t.timestamps null: false
    end

    add_index :locker_room_teams, :type_id
    add_index :locker_room_teams, :subscription_id
    add_index :locker_room_teams, :subdomain
  end
end
