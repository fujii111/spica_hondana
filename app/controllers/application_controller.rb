class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_logined

  # 戻るリクエスト
  def back
    if session[:return_path].blank? || params[:callback].blank?
      redirect_to "/books/list"
    else
      while session[:return_path].last == params[:callback]
        session[:return_path].pop
      end
      redirect_to params[:callback]
    end
  end

  private
  # 認証済みを要求するページで認証されていないとき、ログインページを表示
  def check_logined
    if session[:id].blank?
      session[:request_url] = request.fullpath
      @notice = "ログインが必要です。"
      render "/members/login"
    end
  end

  # 管理者権限を要求するページで認証されていないとき、ログインページを表示
  def check_admin
    unless session[:login_id] == "spica"
      @notice = "要求されたページにアクセスする権限がありません。"
      render "/members/login"
    end
  end
end
