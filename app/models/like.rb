class Like < ApplicationRecord
  validates :user_id, {presence: true}
  validates :item_id, {presence: true}

  belongs_to :user
  belongs_to :item

  def user
    return User.find_by(id: self.user_id)
  end
  def item
    return Item.find_by(id: self.item_id)
  end
end
