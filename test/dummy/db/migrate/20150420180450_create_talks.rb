class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.string :theme
      t.integer :account_id

      t.timestamps null: false
    end
  end
end
