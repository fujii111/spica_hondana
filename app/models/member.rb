class Member < ActiveRecord::Base
  validates :login_id,
    format: { with: /\A[a-zA-Z0-9]*\z/ },
    length: { minimum: 4, maximum: 20 },
    uniqueness: { scope: :delete_flg }
  validates :password,
    format: { with: /\A[a-zA-Z0-9]*\z/ },
    length: { minimum: 8, maximum: 20 },
    confirmation: true
  validates :nickname,
    presence: true
  validates :name,
    presence: true
  validates :address,
    presence: true
  validates :mail_address,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/ }
end
