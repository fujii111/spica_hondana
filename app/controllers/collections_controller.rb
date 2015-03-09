class CollectionsController < ApplicationController

  def index
    @collections = Collection.where(member_id: session[:id], state: 0)
    @completed_collections = Collection.where(member_id: session[:id], state: 2)
    @received_collections = Collection.where(request_member_id: session[:id], state: 2)
    session[:url] = request.fullpath
  end

  def new
    @book = nil
    if params[:id]
      @book = Book.find(params[:id])
    else
#      @book = Book.find_by(isbn: params[:isbn], delete_flg: false)
    end
    @collection = Collection.new
    @collection.height = @book.height
    @collection.width = @book.width
    @collection.depth = @book.depth
  end

end
