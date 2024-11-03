class User < ApplicationRecord

  has_secure_password

  has_many :offered_trades, class_name: 'Trade', foreign_key: 'user_offered_id', dependent: :destroy
  has_many :requested_trades, class_name: 'Trade', foreign_key: 'user_requested_id', dependent: :destroy
  

  validates :name, {presence: true}
  validates :email, {presence: true,uniqueness: true}
  validates :address, {presence: true}

  has_many :items, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy

  def items
    return Item.where(user_id: self.id)
  end

end
