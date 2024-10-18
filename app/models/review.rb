class Review < ApplicationRecord
  validates :point, {presence: true}
  validates :comment, {presence: true}
  validates :user_id, {presence: true}
  validates :item_id, {presence: true}

  def user
    return User.find_by(id: self.user_id)
  end

  def item
    return Item.find_by(id: self.item_id)
  end
end
