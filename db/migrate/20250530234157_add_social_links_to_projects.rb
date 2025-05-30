class AddSocialLinksToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :telegram_url, :string
    add_column :projects, :instagram_url, :string
    add_column :projects, :vkontakte_url, :string
    add_column :projects, :youtube_url, :string
    add_column :projects, :tiktok_url, :string
    add_column :projects, :yandex_zen_url, :string
  end
end
