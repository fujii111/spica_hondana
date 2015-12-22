class Member < ActiveRecord::Base
  has_many :favorites
  has_many :books, through: :favorites

  validates :login_id,
    format: { with: /\A[a-zA-Z0-9]*\z/ },
    length: { minimum: 4, maximum: 20 },
    uniqueness: { scope: :delete_flg }

  validates :password,
    format: { with: /\A[a-zA-Z0-9]*\z/ },
    length: { minimum: 8, maximum: 20 },
    confirmation: true,
    allow_nil: true

  validates :nickname,
    presence: true,
    length: { maximum: 10 }

  # validates :name,
  #   presence: true

  # validates :address,
  #   presence: true

  validates :mail_address,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/ },
    uniqueness: { scope: :delete_flg }

  validates :agreement,
    acceptance: true

  before_create do |member|
    member.password = Digest::MD5.hexdigest(member.password)
  end
end
