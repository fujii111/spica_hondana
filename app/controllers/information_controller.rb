class InformationController < ApplicationController
  skip_before_action :check_logined
  before_action :check_admin, only: :admin

  def top
    @books = Book.where(delete_flg: false, member_id: nil).order(created_at: :desc).limit(20)
    @notices = Notice.order(notice_date: :desc).limit(5)
    render layout: false
  end

  def inquiry
    if session[:id].present?
      member = Member.find(session[:id])
      @name = member.name
      @mail_address = member.mail_address
    end
  end

  def send_mail
    name = params[:name]
    mail_address = params[:mail_address]
    category_id = params[:category_id]
    content = params[:content]
    if name.blank?
      @notice = "お名前が記載されていません。"
    elsif mail_address !~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/
      @notice = "メールアドレスの形式に誤りがあります。"
    elsif content.blank?
      @notice = "お問い合わせ内容が記載されていません。"
    else
      category = Array["会員登録・退会について", "本の登録・検索について", "ポイントについて", "本の発送について", "その他"][category_id.to_i]
      NoticeMailer.inquiry(name, mail_address, category, content).deliver
      return
    end
    render action: "inquiry"
  end
end
