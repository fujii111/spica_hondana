class Book < ActiveRecord::Base
  belongs_to :member

  validates :title,
    presence: true

  validates :width,
    numericality: {greater_than: 0},
    allow_blank: true

  validates :height,
    numericality: {greater_than: 0},
    allow_blank: true

  validates :depth,
    numericality: {greater_than: 0},
    allow_blank: true

  validates :isbn,
    format: { with: /\A[0-9]*\z/ },
    length: { minimum: 10, maximum: 13 },
    uniqueness: { scope: :delete_flg },
    allow_blank: true

  def data=(data)
    self.image = data.read
  end

  # TODO ファイル検証

  before_save do |book|
    book.author.gsub!(/\s|　|/, "")
  end

end
