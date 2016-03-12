class AddResetPasswordTokenToLockerRoomUsers < ActiveRecord::Migration
  def change
    add_column :locker_room_users, :reset_password_token, :string,
      dafault: nil, after: :password_digest
    add_column :locker_room_users, :reset_password_token_expires_at, :datetime,
      dafault: nil, after: :reset_password_token

    add_index :locker_room_users, :reset_password_token
  end
end
