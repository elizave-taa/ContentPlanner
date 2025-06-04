class CreateProjectSpecialists < ActiveRecord::Migration[8.0]
  def change
    create_table :project_specialists do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :project_specialists, [:project_id, :user_id], unique: true
  end
end
