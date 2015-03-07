class BooksController < ApplicationController
  before_action :check_admin, except: [:list, :show, :show_image]
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  skip_before_action :check_logined, only: [:list, :show, :show_image]

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
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:member_id, :title, :publisher, :author, :language, :sale_date, :height, :width, :depth, :isbn, :description, :data)
    end
end
