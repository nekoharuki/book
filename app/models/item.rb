class Item < ApplicationRecord
  validates :name, {presence: true}
  validates :author, {presence: true}
  validates :publisher, {presence: true}
  validates :content, {presence: true,length:{maximum:500,minimum:30}}
  validates :situation, {presence: true}
  validates :category, {presence: true}
  validates :image, {presence: true}
  validates :user_id, {presence: true}

  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy

  belongs_to :user

  def user
    return User.find_by(id: self.user_id)
  end

end
