class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :project_name, null: false
      t.text :project_members, array: true, default: [] # массив участников
      t.bigint :user_id, null: false
      t.text :content_plan
      t.text :comment
      t.string :references, array: true, default: [] # массив ссылок
      t.string :site
      t.string :on_maps, array: true, default: [] # массив карт
      t.string :status, default: 'in_progress'
      t.bigint :specialist_id, null: false
      t.timestamps
    end

    add_index :projects, :user_id
    add_index :projects, :project_name
    # Добавляем GIN индекс для эффективного поиска по массивам
    add_index :projects, :references, using: :gin
    add_index :projects, :networks, using: :gin
  end
end