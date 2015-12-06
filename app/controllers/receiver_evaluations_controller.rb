class ReceiverEvaluationsController < ApplicationController
  def new
    @collection = Collection.find(params[:collection_id])
    @evaluation = Evaluation.new
    @collection_id = @evaluation.collection_id
  end

  def create
    Evaluation.create(create_params)
    @collection = Collection.find(params[:collection_id])
    @request_member = Member.find(@collection.request_member_id)
    @request_member.point = @request_member.point - 1
    @request_member.save!(validate: false)

        message = Message.new(member_id: @collection.member_id, notice_date: DateTime.now, title: "到着のお知らせと評価がありました。",
          content: "『" + @collection.book.title + "』の到着のおしらせと評価がありました。相手の<a href=\"/collections/"  + @collection.id.to_s + "/sender_evaluations/new/" + "\">評価をしてブクを受け取りましょう。</a>",
          read_flg: false)
        message.save

    redirect_to controller: :collections, action: :index
  end

  private
  def create_params
    params.require(:evaluation).permit(:rate, :comment).merge(collection_id: params[:collection_id],state: 1)
  end
end
