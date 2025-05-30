class CreateProjectFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :project_files do |t|
      t.references :project, null: false, foreign_key: true
      t.string :filename
      t.binary :data

      t.timestamps
    end
  end
end
