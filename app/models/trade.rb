class Trade < ApplicationRecord
  belongs_to :user_offered, class_name: 'User', foreign_key: 'user_offered_id', dependent: :destroy
  belongs_to :user_requested, class_name: 'User', foreign_key: 'user_requested_id', dependent: :destroy
  belongs_to :item_offered, class_name: 'Item', foreign_key: 'item_offered_id', dependent: :destroy
  belongs_to :item_requested, class_name: 'Item', foreign_key: 'item_requested_id', dependent: :destroy
  
  validates :item_offered_id, {presence: true}
  validates :user_offered_id, {presence: true}
  validates :item_requested_id, {presence: true}
  validates :user_requested_id, {presence: true}

end
