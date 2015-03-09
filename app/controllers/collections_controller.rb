class CollectionsController < ApplicationController

  def index
    @collections = Collection.where(state: 0)
    session[:url] = request.fullpath
  end

end
