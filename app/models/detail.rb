class Detail < ApplicationRecord
  validates :item_offered_id, {presence: true}
  validates :user_offered_id, {presence: true}
  validates :item_requested_id, {presence: true}
  validates :user_requested_id, {presence: true}

  def user_offered
    return User.find_by(id: self.user_offered_id)
  end

  def item_offered
    return Item.find_by(id: self.item_offered_id)
  end

  def user_requested
    return User.find_by(id: self.user_requested_id)
  end

  def item_requested
    return Item.find_by(id: self.item_requested_id)
  end

end
