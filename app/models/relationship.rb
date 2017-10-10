class Relationship < ApplicationRecord
  belongs_to :invited, class_name: "User"
  belongs_to :invited_by, class_name: "User"
end
