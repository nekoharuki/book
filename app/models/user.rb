class User < ApplicationRecord

  has_secure_password

  validates :name, {presence: true}
  validates :email, {presence: true,uniqueness: true}
  validates :address, {presence: true}

  def items
    return Item.where(user_id: self.id)
  end

end
