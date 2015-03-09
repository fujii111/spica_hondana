class CollectionsController < ApplicationController

  def index
    @collections = Collection.where(member_id: session[:id], state: 0)
    @completed_collections = Collection.where(member_id: session[:id], state: 2)
    @received_collections = Collection.where(request_member_id: session[:id], state: 2)
    session[:url] = request.fullpath
  end

  def new

  end

end
