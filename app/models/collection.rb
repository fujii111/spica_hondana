class Collection < ActiveRecord::Base
  attr_accessor :isbn
  belongs_to :book
  belongs_to :member

  validates :width,
    numericality: {greater_than: 0},
    allow_blank: true

  validates :height,
    numericality: {greater_than: 0},
    allow_blank: true

  validates :depth,
    numericality: {greater_than: 0},
    allow_blank: true

  validates :weight,
    numericality: {greater_than: 0},
    allow_blank: true

end
