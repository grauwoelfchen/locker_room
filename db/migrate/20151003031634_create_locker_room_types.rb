class CreateLockerRoomTypes < ActiveRecord::Migration
  def change
    create_table :locker_room_types do |t|
      t.string :plan_id
      t.string :name
      t.float  :price

      t.timestamps null: false
    end

    add_index :locker_room_types, :plan_id
  end
end
