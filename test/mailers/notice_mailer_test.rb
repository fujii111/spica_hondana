require 'test_helper'

class NoticeMailerTest < ActionMailer::TestCase
  test "send_password_reset_token" do
    mail = NoticeMailer.send_password_reset_token
    assert_equal "Send password reset token", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
