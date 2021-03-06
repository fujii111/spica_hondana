class Book < ActiveRecord::Base
  belongs_to :member
  has_many :favorites
  has_many :members, through: :favorites
  attr_accessor :image_url

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

  # TODO 10または13桁の検証
  validates :isbn,
    format: { with: /\A[0-9]*\z/ },
    length: { minimum: 10, maximum: 13 },
    uniqueness: { scope: :delete_flg },
    allow_blank: true


  def data=(data)
    self.image = data.read
  end

  # ISBNで検索する
  def self.getFromAPIByISBN(isbn)
    condition = Hash.new
    condition["isbn"] = isbn
    condition["hits"] = 1
    json_data = getContent(condition)
    book = Book.new
    book.title = json_data["Items"][0]["Item"]["title"]
    book.author = json_data["Items"][0]["Item"]["author"]
    book.publisher = json_data["Items"][0]["Item"]["publisherName"]
    book.language = "日本語"
    book.sale_date = json_data["Items"][0]["Item"]["salesDate"]
    book.description = json_data["Items"][0]["Item"]["itemCaption"]
    book.image_url = json_data["Items"][0]["Item"]["largeImageUrl"]
    book.isbn = isbn
    return book
  end

  # 検索条件を指定して検索する
  def self.getContent(condition)
    condition.merge!({
        'applicationId' => '1029724767561681573',
        'affiliateId' => '12169043.4164998a.12169044.3519539e',
        'format' => 'json',
        'elements' => 'count,page,first,last,pageCount,title,author,publisherName,size,isbn,itemCaption,salesDate,itemUrl,mediumImageUrl,largeImageUrl,booksGenreName'
    })
    begin
      httpClient = HTTPClient.new
      data = httpClient.get_content('https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522', condition)
      json_data = JSON.parse data
    rescue HTTPClient::BadResponseError => e
    rescue HTTPClient::TimeoutError => e
    end
    return json_data
  end

  # TODO ファイル検証

  before_save do |book|
    book.author.gsub!(/\s|　|/, "")
  end

end
