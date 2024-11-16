class User < ApplicationRecord
  def self.from_omniauth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    if user.new_record?
      existing_user = find_by(email: auth.info.email)
      if existing_user
        user = existing_user
        user.update(provider: auth.provider, uid: auth.uid)
      else
        user.email = auth.info.email
        user.name = auth.info.name
        user.password = SecureRandom.hex(10)
        user.save
      end
    end
    user
  end

  has_secure_password

  has_many :offered_trades, class_name: 'Trade', foreign_key: 'user_offered_id', dependent: :destroy
  has_many :requested_trades, class_name: 'Trade', foreign_key: 'user_requested_id', dependent: :destroy

  has_many :items, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy

  def items
    Item.where(user_id: self.id)
  end
end
