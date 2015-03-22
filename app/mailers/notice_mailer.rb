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
    # TODO base64に変更
    mail from: Property.find(1).inquiry_mail, content_transfer_encoding: '7bit', to: member.mail_address, subject: "[ホンダナ]パスワード再発行用URLのお知らせ"
  end
end
