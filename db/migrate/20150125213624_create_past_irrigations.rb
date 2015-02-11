class CreatePastIrrigations < ActiveRecord::Migration
  def change
    create_table :past_irrigations do |t|
      t.string :Crop
      t.date :Date
      t.integer :Value

      t.timestamps null: false
    end
  end
end
