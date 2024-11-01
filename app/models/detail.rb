class Detail < ApplicationRecord
  validates :item_offered_id, {presence: true}
  validates :user_offered_id, {presence: true}
  validates :item_requested_id, {presence: true}
  validates :user_requested_id, {presence: true}

  def user_offered
    user_offered=User.find_by(id: user_offered_id)
    return user_offered
  end

  def item_offered
    item_offered=Item.find_by(id: item_offered_id)
    return item_offered
  end

  def user_offered
    user_offered=User.find_by(id: user_offered_id)
    return user_offered
  end
  
  def item_offered
    item_offered=Item.find_by(id: item_offered_id)
    return item_offered
  end

end
