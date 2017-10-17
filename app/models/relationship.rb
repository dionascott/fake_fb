class Relationship < ApplicationRecord
  scope :accepted, -> { where(status: true) }
  scope :pending,  -> { where(status: false) }
  belongs_to :invited, class_name: "User"
  belongs_to :invited_by, class_name: "User"

end
