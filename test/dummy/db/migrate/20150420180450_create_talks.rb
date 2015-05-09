class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.string :theme

      t.timestamps null: false
    end
  end
end
