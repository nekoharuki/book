class Item < ApplicationRecord

  has_many :offered_trades, class_name: 'Trade', foreign_key: 'item_offered_id', dependent: :destroy
  has_many :requested_trades, class_name: 'Trade', foreign_key: 'item_requested_id', dependent: :destroy

  mount_uploader :image, ImageUploader
  validates :title, {presence: true}
  validates :author, {presence: true}
  validates :publisher, {presence: true}
  validates :content, presence: true, length: { minimum: 100 }
  validates :condition, {presence: true}
  validates :category, {presence: true}
  validates :user_id, {presence: true}
  validates :status, {presence: true}
  validates :image, {presence: true}

  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy

  belongs_to :user

  def user
    return User.find_by(id: self.user_id)
  end

end
