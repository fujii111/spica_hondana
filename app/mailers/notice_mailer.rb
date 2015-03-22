class NoticeMailer < ActionMailer::Base
  helper ApplicationHelper

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.send_password_reset_token.subject
  #
  def send_password_reset_token(member, request)
    @member = member
    @request = request
    mail from: "postmaster@spica-travel.com", to: member.mail_address, subject: "[ホンダナ]パスワード再発行用URLのお知らせ"
  end

  def inquiry(name, mail_address, category, content)
    @name = name
    @mail_address = mail_address
    @category = category
    @content = content
    mail from: @mail_address, to: Property.find(1).inquiry_mail, subject: "[ホンダナ]問い合わせ"
  end
end
