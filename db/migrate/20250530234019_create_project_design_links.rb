class CreateProjectDesignLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :project_design_links do |t|
      t.references :project, null: false, foreign_key: true
      t.string :url

      t.timestamps
    end
  end
end
