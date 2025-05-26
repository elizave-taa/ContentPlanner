class AddFieldsToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :description, :text
    add_reference :projects, :creator, foreign_key: { to_table: :users }
    add_column :projects, :website_url, :string
    add_column :projects, :map_url, :string
  end
end
