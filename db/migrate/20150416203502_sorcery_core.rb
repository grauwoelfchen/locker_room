class SorceryCore < ActiveRecord::Migration
  def change
    create_table :locker_room_users do |t|
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt

      t.timestamps null: false
    end

    add_index :locker_room_users, :email, unique: true
  end
end
