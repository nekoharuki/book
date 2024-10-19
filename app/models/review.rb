class Review < ApplicationRecord
  validates :point, {presence: true,length:{maximum:5,minimum:1}}
  validates :comment, {presence: true,length:{maximum:100,minimum:20}}
  validates :user_id, {presence: true}
  validates :item_id, {presence: true}

  def user
    return User.find_by(id: self.user_id)
  end

  def item
    return Item.find_by(id: self.item_id)
  end
end
