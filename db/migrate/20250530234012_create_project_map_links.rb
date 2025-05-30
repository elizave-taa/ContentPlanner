class CreateProjectMapLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :project_map_links do |t|
      t.references :project, null: false, foreign_key: true
      t.string :url

      t.timestamps
    end
  end
end
