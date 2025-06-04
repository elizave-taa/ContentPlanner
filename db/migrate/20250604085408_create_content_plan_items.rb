class CreateContentPlanItems < ActiveRecord::Migration[8.0]
  def change
    create_table :content_plan_items do |t|
      t.references :project, null: false, foreign_key: true
      t.text :title, null: false
      t.boolean :posted, default: false
      t.date :deadline
      t.integer :platform, null: false
      t.json :tags, default: []

      t.timestamps
    end

    add_index :content_plan_items, :posted
    add_index :content_plan_items, :deadline
    add_index :content_plan_items, :platform
  end
end
