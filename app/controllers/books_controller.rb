class BooksController < ApplicationController
  before_action :check_admin,
    except: [:list, :show, :show_image, :search, :search_edit, :search_detail, :favorite, :delete_favorite]
  before_action :set_book, only: [:show, :edit, :update, :destroy, :favorite]
  skip_before_action :check_logined,
    only: [:list, :show, :show_image, :search, :search_edit, :search_detail]

  # トップページの表示
  def list
    @books = Book.where(delete_flg: false, member_id: nil)
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 50)
    @notices = Notice.order(notice_date: :desc)
      .limit(5)
  end

  # 書籍一覧表示
  def index
    @books = Book.where(delete_flg: false)
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 50)
  end

  # 書籍検索
  def search
    session[:keyword] = params[:keyword]
    @keyword = params[:keyword].gsub(/\s|　|/, "")
    if @keyword.blank?
      @notice = "検索キーワードを指定してください。"
      return
    end
    @books = Book.where("title like ? or author like ?", "%" + @keyword + "%", "%" + @keyword + "%").where(delete_flg: false)

    # API経由
    condition = Hash.new
    condition["title"] = @keyword
    condition["hits"] = 30
    @json_title_data = Book.getContent(condition)
    condition["author"] = @keyword
    @json_author_data = Book.getContent(condition)

    # begin
      # httpClient = HTTPClient.new
      # author_data = httpClient.get_content('https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522', {
        # 'applicationId' => '1029724767561681573',
        # 'affiliateId' => '12169043.4164998a.12169044.3519539e',
        # 'format' => 'json',
        # 'elements' => 'count,page,first,last,pageCount,title,author,publisherName,size,isbn,itemCaption,salesDate,itemUrl,mediumImageUrl,booksGenreName',
        # 'author' => @keyword,
        # 'hits' => '30'
      # })
      # title_data = httpClient.get_content('https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522', {
        # 'applicationId' => '1029724767561681573',
        # 'affiliateId' => '12169043.4164998a.12169044.3519539e',
        # 'format' => 'json',
        # 'elements' => 'count,page,first,last,pageCount,title,author,publisherName,size,isbn,itemCaption,salesDate,itemUrl,mediumImageUrl,booksGenreName',
        # 'title' => @keyword,
        # 'hits' => '30'
      # })
      # @json_title_data = JSON.parse title_data
      # @json_author_data = JSON.parse author_data
    # rescue HTTPClient::BadResponseError => e
    # rescue HTTPClient::TimeoutError => e
    # end
    session[:return_path] = Array[request.fullpath]
  end

  # 書籍詳細検索
  def search_detail
    @title_keyword = params[:title_keyword].gsub(/\s|　|/, "")
    @author_keyword = params[:author_keyword].gsub(/\s|　|/, "")
    @publisher_keyword = params[:publisher_keyword].gsub(/\s|　|/, "")
    @isbn_keyword = params[:isbn_keyword].gsub(/\s|　|/, "")
    if @title_keyword.blank? && @author_keyword.blank? && @publisher_keyword.blank? && @isbn_keyword.blank?
      @notice = "検索キーワードを少なくとも一つ指定してください。"
      render action: "search_edit"
      return
    end
    @books = Book.where("title like ? and author like ? and publisher like ? and isbn like ?",
     "%" + @title_keyword + "%", "%" + @author_keyword + "%", "%" + @publisher_keyword + "%", "%" + @isbn_keyword + "%")
     .where(delete_flg: false)
    begin
      httpClient = HTTPClient.new
      condition = {
        'applicationId' => '1029724767561681573',
        'affiliateId' => '12169043.4164998a.12169044.3519539e',
        'format' => 'json',
        'elements' => 'count,page,first,last,pageCount,title,author,publisherName,size,isbn,itemCaption,salesDate,itemUrl,mediumImageUrl,booksGenreName',
        'hits' => '30'
      }
      condition['title'] = @title_keyword if !@title_keyword.blank?
      condition['author'] = @author_keyword if !@author_keyword.blank?
      condition['publisherName'] = @publisher_keyword if !@publisher_keyword.blank?
      condition['isbn'] = @isbn_keyword if !@isbn_keyword.blank?
      title_data = httpClient.get_content('https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522', condition)
      @json_title_data = JSON.parse title_data
    rescue HTTPClient::BadResponseError => e
    rescue HTTPClient::TimeoutError => e
    end
    session[:return_path] = Array[request.fullpath]
    render action: "search"
  end

  # 書籍情報表示
  def show
    # お気に入りに登録されているか確認
    @favorite = nil
    if session[:id] != nil
      @favorite = Favorite.find_by(book_id: @book.id, member_id: session[:id])
    end
  end

  # 書籍の画像表示
  def show_image
    @book = Book.find_by(isbn: params[:isbn], delete_flg: false)
    if @book.blank? || @book.image.blank?
      send_file "./app/assets/images/noimage.jpg", disposition: :inline
    else
      send_data @book.image, disposition: :inline
    end
  end

  # 書籍登録フォーム表示
  def new
    @book = Book.new
  end

  # 書籍変更フォーム表示
  def edit
  end

  # 書籍登録
  def create
    @book = Book.new(book_params)
    @book.delete_flg = false
    if @book.save
      redirect_to @book, notice: '書籍が登録されました。'
    else
      render action: 'new'
    end
  end

  # 書籍更新
  def update
    if @book.update(book_params)
      redirect_to @book, notice: '書籍が更新されました。'
    else
      render action: 'edit'
    end
  end

  # 書籍削除
  def destroy
    @book.destroy
    redirect_to books_url
  end

  # お気に入りに追加
  def favorite
    favorite = Favorite.find_by(book_id: @book.id, member_id: session[:id])
    if favorite == nil
      favorite = Favorite.new(book_id: @book.id, member_id: session[:id], create_date: DateTime.now)
    else
      favorite.create_date = DateTime.now
    end
    favorite.save!
    redirect_to @book
  end

  # お気に入りから削除
  def delete_favorite
    favorite = Favorite.find_by(book_id: params[:id], member_id: session[:id])
    favorite.destroy
    redirect_to "/collections/"
  end

  private
    def set_book
      @book = Book.find_by(id: params[:id], delete_flg: false)
    end

    def book_params
      params.require(:book).permit(:member_id, :title, :publisher, :author, :language, :sale_date, :height, :width, :depth, :isbn, :description, :data)
    end
end
