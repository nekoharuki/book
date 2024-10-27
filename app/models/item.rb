class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  validates :name, {presence: true}
  validates :author, {presence: true}
  validates :publisher, {presence: true}
  validates :content, {presence: true}
  validates :condition, {presence: true}
  validates :category, {presence: true}
  validates :user_id, {presence: true}
  validates :image, {presence: true}
  validates :status, {presence: true}

  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy

  belongs_to :user

  def user
    return User.find_by(id: self.user_id)
  end

end
