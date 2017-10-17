class Like < ApplicationRecord
  belongs_to :post
  belongs_to :liker, class_name: "User"

  validates :liker_id, uniqueness: { scope: :post_id }
end
