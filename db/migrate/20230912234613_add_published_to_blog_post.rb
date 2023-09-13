class AddPublishedToBlogPost < ActiveRecord::Migration[7.0]
  def change
    add_column :blog_posts, :published, :boolean, default: false
  end
end
