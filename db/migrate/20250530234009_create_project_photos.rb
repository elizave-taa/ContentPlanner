class CreateProjectPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :project_photos do |t|
      t.references :project, null: false, foreign_key: true
      t.string :url
      t.string :title

      t.timestamps
    end
  end
end
