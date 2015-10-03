class CreateLockerRoomPlans < ActiveRecord::Migration
  def change
    create_table :locker_room_plans do |t|
      t.string :name
      t.float :price
      t.string :braintree_id

      t.timestamps null: false
    end
  end
end