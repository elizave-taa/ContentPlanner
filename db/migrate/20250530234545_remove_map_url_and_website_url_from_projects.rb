class RemoveMapUrlAndWebsiteUrlFromProjects < ActiveRecord::Migration[8.0]
  def change
    remove_column :projects, :map_url, :string
    remove_column :projects, :website_url, :string
  end
end
