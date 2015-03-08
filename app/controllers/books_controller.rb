class BooksController < ApplicationController
  before_action :check_admin, except: [:list, :show, :show_image, :search]
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  skip_before_action :check_logined, only: [:list, :show, :show_image, :search]

  def list
    @books = Book.where(delete_flg: false, member_id: nil).order(created_at: :desc).limit(10)
    @notices = Notice.order(notice_date: :desc).limit(5)
    session[:url] = request.fullpath
  end

  # GET /books
  # GET /books.json
  def index
    @books = Book.where(delete_flg: false).order(created_at: :desc).limit(10)
    session[:url] = request.fullpath
  end

  def search
    session[:keyword] = params[:keyword]
    @keyword = params[:keyword].gsub(/\s|　|/, "")
    if @keyword.blank?
      @notice = "検索キーワードを指定してください。"
      return
    end
    @books = Book.where("title like ? or author like ?", "%" + @keyword + "%", "%" + @keyword + "%").where(delete_flg: false)
    session[:url] = request.fullpath
  end

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
    session[:url] = request.fullpath
    render action: "search"
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  def show_image
    @book = Book.find_by(isbn: params[:isbn], delete_flg: false)
    if @book.blank? || @book.image.blank?
      send_file "./app/assets/images/noimage.jpg", disposition: :inline
    else
      send_data @book.image, disposition: :inline
    end
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    @book.delete_flg = false
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: '書籍が登録されました。' }
        format.json { render action: 'show', status: :created, location: @book }
      else
        format.html { render action: 'new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: '書籍が更新されました。' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find_by(id: params[:id], delete_flg: false)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:member_id, :title, :publisher, :author, :language, :sale_date, :height, :width, :depth, :isbn, :description, :data)
    end
end
