class CreateLockerRoomAccounts < ActiveRecord::Migration
  def change
    create_table :locker_room_accounts do |t|
      t.string  :name
      t.string  :subdomain
      t.integer :owner_id

      t.timestamps null: false
    end

    add_index :locker_room_accounts, :owner_id
  end
end
