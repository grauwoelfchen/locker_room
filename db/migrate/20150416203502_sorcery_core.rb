class SorceryCore < ActiveRecord::Migration
  def change
    create_table :locker_room_users do |t|
      t.integer :account_id
      t.string  :email, null: false
      t.string  :crypted_password
      t.string  :salt

      t.timestamps null: false
    end

    add_index :locker_room_users, [:account_id, :email], unique: true
  end
end
