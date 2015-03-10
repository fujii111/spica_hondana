class CollectionsController < ApplicationController

  def index
    @collections = Collection.where("member_id = " + session[:id].to_s + " and state < 8")
      .order(state: :desc, regist_date: :desc)
    @completed_collections = Collection.where(member_id: session[:id], state: 8)
    @received_collections = Collection.where(request_member_id: session[:id], state: 8)
    session[:url] = request.fullpath
  end

  def new
    if params[:id].present?
      @book = Book.find(params[:id])
    else
      @book = Book.find_by(isbn: params[:isbn], delete_flg: false)
      if @book.blank?
        @book = Book.getFromAPIByISBN(params[:isbn])
      end
    end
    if session[:collection]
      @collection = Collection.new(session[:collection])
    else
      @collection = Collection.new
      @collection.height = @book.height
      @collection.width = @book.width
      @collection.depth = @book.depth
    end
  end

  def confirm
    collection_params = params.require(:collection).permit(:book_id, :isbn, :condition, :band, :sunburn, :scratch, :cigar, :pet, :mold, :height, :width, :depth, :weight, :line, :broken, :note)
    if params[:collection][:book_id].present?
      @book = Book.find(params[:collection][:book_id])
    else
      @book = Book.getFromAPIByISBN(params[:collection][:isbn])
    end
    @collection = Collection.new(collection_params)
    if @collection.valid?
      session[:collection] = collection_params
      render action: 'confirm'
    else
      render action: 'new'
    end
  end

  def create
    collection_params = params.require(:collection).permit(:book_id, :isbn, :condition, :band, :sunburn, :scratch, :cigar, :pet, :mold, :height, :width, :depth, :weight, :line, :broken, :note)
    id = params[:collection][:book_id]
    if params[:collection][:book_id].blank?
      @book = Book.getFromAPIByISBN(params[:collection][:isbn])
      @book.delete_flg = false
      httpClient = HTTPClient.new
      @book.image = httpClient.get_content(@book.image_url)
      unless @book.save
        render action: 'new'
        return
      end
      id = @book.id
    end
    @collection = Collection.new(collection_params)
    @collection.member_id = session[:id]
    @collection.book_id = id
    @collection.state = 0
    @collection.regist_date = DateTime.now
    if @collection.save
      session[:collection] = nil
      member = Member.find(session[:id])
      member.point = member.point + 1
      member.save(validate: false)
      session[:point] = member.point
      redirect_to action: "complete"
    else
      render action: 'new'
    end
  end

end
