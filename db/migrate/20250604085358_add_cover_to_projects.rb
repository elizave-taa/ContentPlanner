class AddCoverToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :cover, :binary
  end
end
