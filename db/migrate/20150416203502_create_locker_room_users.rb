class CreateLockerRoomUsers < ActiveRecord::Migration
  def change
    create_table :locker_room_users do |t|
      t.integer :team_id
      t.string  :username
      t.string  :name
      t.string  :email, null: false
      t.string  :crypted_password
      t.string  :salt

      t.timestamps null: false
    end

    add_index :locker_room_users, [:team_id, :email],    unique: true
    add_index :locker_room_users, [:team_id, :username], unique: true
  end
end
