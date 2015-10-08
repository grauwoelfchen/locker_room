class CreateLockerRoomMateships < ActiveRecord::Migration
  def change
    create_table :locker_room_mateships do |t|
      t.integer :team_id
      t.integer :user_id
      t.integer :role, default: 1, limit: 1

      t.timestamps null: false
    end

    add_index :locker_room_mateships, :team_id
    add_index :locker_room_mateships, :user_id
  end
end
