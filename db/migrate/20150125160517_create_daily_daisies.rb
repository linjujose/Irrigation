class CreateDailyDaisies < ActiveRecord::Migration
  def change
    create_table :daily_daisies do |t|
      t.string :Stn_name
      t.date :Date
      t.integer :JulianYear
      t.float :MaxAirTem
      t.float :MinAirTemp
      t.integer :MaxRelHum
      t.integer :MinRelHum
      t.float :Precip
      t.float :Eto
      t.float :MaxWindSpeed
      t.timestamps null: false
    end
  end
end
