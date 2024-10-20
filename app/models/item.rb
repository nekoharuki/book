class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  validates :name, {presence: true,length:{maximum:20}}
  validates :author, {presence: true,length:{maximum:20}}
  validates :publisher, {presence: true,length:{maximum:20}}
  validates :content, {presence: true,length:{maximum:500,minimum:30}}
  validates :situation, {presence: true}
  validates :category, {presence: true,length:{maximum:20}}
  validates :user_id, {presence: true}
  validates :image, {presence: true}

  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy

  belongs_to :user

  def user
    return User.find_by(id: self.user_id)
  end

end
