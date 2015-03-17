class InformationController < ApplicationController
  skip_before_action :check_logined
  before_action :check_admin, only: :admin

  def top
    @books = Book.where(delete_flg: false, member_id: nil).order(created_at: :desc).limit(20)
    @notices = Notice.order(notice_date: :desc).limit(5)
    render layout: false
  end
end
