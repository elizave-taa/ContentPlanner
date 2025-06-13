class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.references :project, null: false, foreign_key: true, index: { unique: true }
      t.date       :start_date, null: false
      t.json       :weekdays,    null: false, default: []

      t.timestamps
    end
  end
end
