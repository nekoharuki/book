class Detail < ApplicationRecord
  validates :item_offered_id, {presence: true}
  validates :user_offered_id, {presence: true}
  validates :item_requested_id, {presence: true}
  validates :user_requested_id, {presence: true}

  belongs_to :user
end
