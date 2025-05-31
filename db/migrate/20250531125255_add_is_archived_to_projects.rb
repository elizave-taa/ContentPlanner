class AddIsArchivedToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :is_archived, :boolean, default: false
  end
end
