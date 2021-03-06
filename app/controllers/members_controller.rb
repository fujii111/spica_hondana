class MembersController < ApplicationController
  skip_before_action :check_logined, only: [:new, :confirm, :create, :authenticate, :login, :logout, :forget_password, :send_mail_token, :confirm_mail_token, :reset_password]
  before_action :check_admin, only: [:index, :login_as]

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
      render action: "confirm"
    else
      render action: "new"
    end
  end

  # 新規会員登録
  def create
    @member = Member.new(session[:member])
    @member.point = 0
    @member.delete_flg = false
    if @member.save
      # ログイン処理
      session[:member] = nil
      session[:id] = @member.id
      session[:login_id] = @member.login_id
      session[:nickname] = @member.nickname
      session[:point] = @member.point

      # メッセージの作成
      message = Message.new(member_id: session[:id], notice_date: DateTime.now, title: "ようこそホンダナへ",
        content: "新しい書籍の形を提案するサービスを是非ご利用ください。", read_flg: false)
      message.save
      session[:message] = true
      redirect_to action: "complete"
    else
      render action: "new"
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
      render action: "edit"
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
      redirect_to action: "updated_password"
    else
      render action: "edit_password"
    end
  end

  # パスワード忘れメール送信
  def send_mail_token
    @member = Member.find_by(mail_address: params[:mail_address], delete_flg: false)
    if @member.blank?
      @notice = "指定したメールアドレスの会員が見つかりません。メールアドレスは正しく入力してください。"
      @mail_address = params[:mail_address]
      render action: "forget_password"
      return
    else
      @member.reset_token = SecureRandom.uuid
      @member.reset_limit = DateTime.now + 1
      @member.save!(validate: false)
      NoticeMailer.send_password_reset_token(@member, request).deliver
    end
  end

  # パスワード忘れメール確認
  def confirm_mail_token
    @member = Member.where(reset_token: params[:reset_token], delete_flg: false).where("reset_limit > ?", DateTime.now)[0]
    if @member.blank?
      @notice = "無効なURLです。"
    else
      session[:reset_token] = params[:reset_token]
    end
  end

  # パスワード再設定
  def reset_password
    @member = Member.where(reset_token: session[:reset_token], delete_flg: false).where("reset_limit > ?", DateTime.now)[0]
    if @member.blank?
      @notice = "無効なリクエストです。"
      render action: "confirm_mail_token"
      return
    end
    @member.password = params[:password]
    @member.password_confirmation = params[:password_confirmation]
    @member.reset_limit = DateTime.now
    if @member.valid?
      @member.password = Digest::MD5.hexdigest(@member.password)
      @member.save!(validate: false)
      session[:reset_token] = nil
    else
      render action: "confirm_mail_token"
    end
  end

  # 退会確認
  def exit
    @requested_collections = Collection.where(member_id: session[:id], state: 1)
    @requesting_collections = Collection.where(request_member_id: session[:id], state: 1)
    if @requested_collections.present? || @requesting_collections.present?
      @notice = "発送処理待ちの本があるため、退会できません。"
    end
  end

  # 退会
  def destroy
    @requested_collections = Collection.where(member_id: session[:id], state: 1)
    @requesting_collections = Collection.where(request_member_id: session[:id], state: 1)
    if @requested_collections.present? || @requesting_collections.present?
      @notice = "発送処理待ちの本があるため、退会できません。"
      render action: "exit"
      return
    end
    @member = Member.find(session[:id])
    @member.delete_flg = true
    @member.save!(validate: false)
    Collection.where(member_id: session[:id], state: 0).update_all(state: 9)
    session[:id] = nil
    session[:login_id] = nil
    session[:nickname] = nil
    session[:point] = nil
    session[:request_url] = nil
    session[:message] = nil
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
      session[:login_id] = member.login_id
      session[:nickname] = member.nickname
      session[:point] = member.point
      if Message.where(member_id: session[:id], read_flg: false).count > 0
        session[:message] = true
      end
      if session[:request_url].blank?
        redirect_to "/collections/"
      else
        redirect_to session[:request_url]
      end
    end
  end

  # ログイン(管理者機能)
  def login_as
    member = Member.find(params[:id], :conditions => {:delete_flg => false})
    session[:id] = member.id
    session[:login_id] = member.login_id
    session[:nickname] = member.nickname
    session[:point] = member.point
    if Message.where(member_id: session[:id], read_flg: false).count > 0
      session[:message] = true
    end
    redirect_to "/collections/"
  end

  # ログアウト
  def logout
    session[:id] = nil
    session[:login_id] = nil
    session[:nickname] = nil
    session[:point] = nil
    session[:request_url] = nil
    session[:message] = nil
    redirect_to "/"
  end


 # 自分の評価
  def evaluation
    @member = Member.find(session[:id])
    @verygood = []
    @good = []
    @bad = []
    member = Member.find(session[:id])
    my_evaluation = member.evaluation_about_self
    @evaluations = my_evaluation
    my_evaluation.each do |evaluation|
      if evaluation.rate == 2
        @good << evaluation
      elsif evaluation.rate == 1
        @verygood << evaluation
      else
        @bad << evaluation
      end
    end
  end


  # 本を持ってる人の評価
  def evaluations
    @verygood = []
    @good = []
    @bad = []
    member = Member.find_by(id: params[:member_id])
    my_evaluation = member.evaluation_about_self
    @evaluations = my_evaluation

    my_evaluation.each do |evaluation|
      if evaluation.rate == 2
        @good << evaluation
      elsif evaluation.rate == 1
        @verygood << evaluation
      else
        @bad << evaluation
      end
    end
  end

end
