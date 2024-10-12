class Item < ApplicationRecord
  validates :name, {presence: true}
  validates :author, {presence: true}
  validates :publisher, {presence: true}
  validates :content, {presence: true}
  validates :situation, {presence: true}
  validates :category, {presence: true}
  validates :image, {presence: true}

end
