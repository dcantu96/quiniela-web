class BlogPost < ApplicationRecord
  scope :published, -> { where(published: true) }
  has_rich_text :content
end
