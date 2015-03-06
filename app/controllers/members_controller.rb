class MembersController < ApplicationController
  # 会員一覧(管理者機能)
  def index
    @members = Member.where(delete_flg: false)
  end

  # 新規会員登録フォーム画面表示
  def new
    if session[:member].blank?
      @member = Member.new
    else
      @member = Member.new(session[:member])
    end
  end

  # 新規会員登録確認
  def confirm
    member_params = params.require(:member).permit(:login_id, :password, :password_confirmation, :name, :kana, :nickname, :birthday, :mail_address, :address, :agreement, :favorite_author1, :favorite_author2, :favorite_author3)
    @member = Member.new(member_params)
    if @member.valid?
      session[:member] = member_params
      render action: 'confirm'
    else
      render action: 'new'
    end
  end

  # 新規会員登録
  def create
    @member = Member.new(session[:member])
    @member.point = 0
    @member.delete_flg = false
    if @member.save
      session[:member] = nil
      session[:id] = @member.id
      session[:nickname] = @member.nickname
      session[:point] = @member.point
      redirect_to action: "complete"
    else
      render action: 'new'
    end
  end

  # プロフィール表示
  def show
    @member = Member.find(session[:id])
  end

  # プロフィール編集フォーム画面表示
  def edit
    @member = Member.find(session[:id])
  end

  # プロフィール変更
  def update
    member_params = params.require(:member).permit(:name, :kana, :nickname, :birthday, :mail_address, :address, :favorite_author1, :favorite_author2, :favorite_author3)
    @member = Member.find(session[:id])

    # パスワードを検証しないため、一旦退避してnilにする
    # (検証ありにすると、暗号化済パスワードを検証するためパスワード20字以内のチェックでエラーになる)
    password = @member.password
    @member.password = nil

    if @member.update(member_params)
      # パスワードを検証なしで戻す
      @member.password = password
      @member.save!(validate: false)

      session[:nickname] = @member.nickname
      flash[:notice] = "プロフィールを変更しました。"
      redirect_to action: "show"
    else
      render action: 'edit'
    end
  end

  # パスワード変更フォーム画面表示
  def edit_password
    @member = Member.find(session[:id])
  end

  # パスワード変更
  def update_password
    member_params = params.require(:member).permit(:password, :password_confirmation)
    @member = Member.find(session[:id])
    @member.attributes = member_params
    if @member.valid?
      @member.password = Digest::MD5.hexdigest(@member.password)
      @member.save!(validate: false)
      redirect_to action: 'updated_password'
    else
      render action: 'edit_password'
    end
  end

  # 退会
  def destroy
    @member.delete_flg = true
    @member.save!(validate: false)
    redirect_to action: "show"
  end

  # ログイン認証
  def authenticate
    @login_id = params[:login_id]
    password = Digest::MD5.hexdigest(params[:password])
    member = Member.find_by(login_id: @login_id, password: password, delete_flg: false)
    if member.blank?
      @notice = "ログインIDまたはパスワードに誤りがあります。"
      render action: "login"
    else
      session[:id] = member.id
      session[:nickname] = member.nickname
      session[:point] = member.point
      redirect_to books_path
    end
  end

  # ログイン(管理者機能)
  def login_as
    member = Member.find(params[:id], :conditions => {:delete_flg => false})
    session[:id] = member.id
    session[:nickname] = member.nickname
    session[:point] = member.point
    redirect_to books_path
  end

  # ログアウト
  def logout
    session[:id] = nil
    session[:nickname] = nil
    session[:point] = nil
    redirect_to root_path
  end
end
