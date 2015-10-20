class CreateLockerRoomUsers < ActiveRecord::Migration
  def change
    create_table :locker_room_users do |t|
      t.string  :username
      t.string  :name
      t.string  :email, null: false
      t.string  :password_digest

      t.timestamps null: false
    end

    add_index :locker_room_users, :email,    unique: true
    add_index :locker_room_users, :username, unique: true
  end
end
