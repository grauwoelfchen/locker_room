class CreateLockerRoomMembers < ActiveRecord::Migration
  def change
    create_table :locker_room_members do |t|
      t.integer :account_id
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :locker_room_members, :account_id
    add_index :locker_room_members, :user_id
  end
end
