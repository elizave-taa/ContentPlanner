class AddCodeAndExpireToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :code, :string
    add_column :projects, :expire_in, :date
  end
end
