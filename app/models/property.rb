class Property < ActiveRecord::Base
  validates :inquiry_mail,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/ }

  validates :clickpost_url,
    format: { with: /\Ahttp/ }

  validates :request_limit,
    numericality: {greater_than_or_equal_to: 0}

  validates :default_point,
    numericality: {greater_than_or_equal_to: 0}

end
