class CreateLockerRoomMemberships < ActiveRecord::Migration
  def change
    create_table :locker_room_memberships do |t|
      t.integer :team_id
      t.integer :user_id
      t.integer :role, default: 1, limit: 1
      t.string  :name

      t.timestamps null: false
    end

    add_index :locker_room_memberships, :team_id
    add_index :locker_room_memberships, :user_id
  end
end
