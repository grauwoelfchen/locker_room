class CreateLockerRoomAccounts < ActiveRecord::Migration
  def change
    create_table :locker_room_accounts do |t|
      t.string  :name
      t.string  :subdomain

      t.timestamps null: false
    end

    add_index :locker_room_accounts, :subdomain
  end
end
