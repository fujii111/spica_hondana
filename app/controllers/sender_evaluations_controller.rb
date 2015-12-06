class SenderEvaluationsController < ApplicationController
  def new
    @collection = Collection.find(params[:collection_id])
    @evaluation = Evaluation.new
    @collection_id = @evaluation.collection_id
  end

  def create
    Evaluation.create(create_params)
      # 発送者のブクを増やす
      @collection = Collection.find(create_params[:collection_id])
      @member = Member.find(@collection.member_id)
      @member.point = @member.point + 1
      @member.save!(validate: false)
      session[:point] = @collection.member.point

      message = Message.new(member_id: @collection.request_member_id, notice_date: DateTime.now, title: "評価されました",
        content: "あなたへ『" + @collection.book.title + "』の発送者から評価がつきました",
        read_flg: false)
      message.save

    redirect_to controller: :collections, action: :index
  end

  private
  def create_params
    params.require(:evaluation).permit(:rate, :comment).merge(collection_id: params[:collection_id],state: 0)
  end
end
