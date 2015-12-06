class Member < ActiveRecord::Base
  has_many :favorites
  has_many :books, through: :favorites
  has_many :collections
  has_many :requested_collections, class_name: "Collection", foreign_key: :request_member_id
  has_many :evaluations_a, -> { where(state: 1) }, source: :evaluations, through: :collections
  has_many :evaluations_b, -> { where(state: 0) }, source: :evaluations, through: :requested_collections
  
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

  validates :name,
    presence: true

  validates :address,
    presence: true

  validates :mail_address,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/ },
    uniqueness: { scope: :delete_flg }

  validates :agreement,
    acceptance: true

  before_create do |member|
    member.password = Digest::MD5.hexdigest(member.password)
  end

  def evaluation_about_self
    array = evaluations_a + evaluations_b
    array.sort do |b, a|
      a.created_at <=> b.created_at
    end
    array
  end

  def rate_average
    sum = 0
    evaluation_about_self.each do |evaluation|
      sum += evaluation.rate
    end

    sum / evaluation_about_self.count
  end
end
