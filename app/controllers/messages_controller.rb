class MessagesController < ApplicationController

  # 会員向け告知を表示
  def index
    @messages = Message.where(member_id: session[:id]).order(notice_date: :desc)
  end

  # 既読フラグを立てる
  def read
    message = Message.find_by(id: params[:id], member_id: session[:id])
    if message != nil
      message.read_flg = true
      message.save
      if Message.where(member_id: session[:id], read_flg: false).count == 0
        session[:message] = nil
      end
    end
    render text: "complete"
  end

end
