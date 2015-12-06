class CollectionsController < ApplicationController

  # マイページ
  def index
    @collections = Collection.where(member_id: session[:id], state: 0)
      .order(regist_date: :desc)
    @requested_collections = Collection.where(member_id: session[:id], state: 1)
    @completed_collections = Collection.where(member_id: session[:id], state: 8)
      .order(send_date: :desc)
    @favorites = Favorite.where(member_id: session[:id]).order(create_date: :desc)
    @received_collections = Collection.where(request_member_id: session[:id], state: 8)
      .order(request_date: :desc)
  end

  # 交換一覧
  def list
    @requested_collections = Collection.where(member_id: session[:id], state: 1)
      .order(request_date: :desc)
    @completed_collections = Collection.where(member_id: session[:id], state: 8)
      .order(send_date: :desc)
    @requesting_collections = Collection.where(request_member_id: session[:id], state: 1)
      .order(request_date: :desc)
    @received_collections = Collection.where(request_member_id: session[:id], state: 8)
      .order(request_date: :desc)
  end

  # 蔵書の新規登録フォーム
  def new
    if params[:id].present?
      @book = Book.find(params[:id])
    else
      @book = Book.find_by(isbn: params[:isbn], delete_flg: false)
      if @book.blank?
        @book = Book.getFromAPIByISBN(params[:isbn])
      end
    end
    if session[:collection]
      @collection = Collection.new(session[:collection])
    else
      @collection = Collection.new
      @collection.height = @book.height
      @collection.width = @book.width
      @collection.depth = @book.depth
    end
  end

  # 蔵書の新規登録確認
  def confirm
    collection_params = params.require(:collection).permit(:book_id, :isbn, :condition, :band, :sunburn, :scratch, :cigar, :pet, :mold, :height, :width, :depth, :weight, :line, :broken, :note)
    if params[:collection][:book_id].present?
      @book = Book.find(params[:collection][:book_id])
    else
      @book = Book.getFromAPIByISBN(params[:collection][:isbn])
    end
    @collection = Collection.new(collection_params)
    if @collection.valid?
      session[:collection] = collection_params
      render action: "confirm"
    else
      render action: "new"
    end
  end

  # 蔵書の新規登録
  def create
    collection_params = params.require(:collection).permit(:book_id, :isbn, :condition, :band, :sunburn, :scratch, :cigar, :pet, :mold, :height, :width, :depth, :weight, :line, :broken, :note)
    id = params[:collection][:book_id]
    if params[:collection][:book_id].blank?

      # API経由の場合はまず書籍情報を新規登録
      @book = Book.getFromAPIByISBN(params[:collection][:isbn])
      @book.delete_flg = false
      httpClient = HTTPClient.new
      @book.image = httpClient.get_content(@book.image_url)
      unless @book.save
        render action: "new"
        return
      end
      id = @book.id

    end

    # 蔵書の新規登録
    @collection = Collection.new(collection_params)
    @collection.member_id = session[:id]
    @collection.book_id = id
    @collection.state = 0
    @collection.regist_date = DateTime.now
    if @collection.save
      session[:collection] = nil
      member = Member.find(session[:id])
      member.point = member.point + 1
      member.save(validate: false)
      session[:point] = member.point
      redirect_to action: "complete"
    else
      render action: "new"
    end
  end

  # 蔵書の編集フォーム
  def edit
    @collection = Collection.find(params[:id])
    if @collection.member_id != session[:id] || @collection.state != 0
      @message = "この本は編集できません。"
    end
  end

  # 蔵書の編集
  def update
    collection_params = params.require(:collection).permit(:id, :condition, :band, :sunburn, :scratch, :cigar, :pet, :mold, :height, :width, :depth, :weight, :line, :broken, :note)
    @collection = Collection.find(collection_params[:id])
    if @collection.update(collection_params)
      redirect_to action: "show", id: collection_params[:id]
    else
      render action: "edit"
    end
  end

  # 蔵書の出品取り消し
  def destroy
    collection = Collection.find(params[:id])
    member = Member.find(session[:id])
    if collection.member_id != session[:id]
      @message = "他の人の出品取り消しはできません。"
    elsif collection.state > 0
      @message = "既に申請されているため、出品取り消しできません。"
    elsif member.point - Collection.where(request_member_id: session[:id], state: 1).count <= 0
      @message = "ブクが足りなくなるため出品取り消しできません。出品取り消しするには、別の本を登録して再度取り消しを行ってください。"
    else
      collection.state = 9
      if collection.save
        member.point = member.point - 1
        session[:point] = member.point
        member.save(validate: false)
        @message = "出品取り消ししました。"
      else
        @message = "処理エラーです。"
      end
    end
  end

  # 蔵書の詳細
  def show
    @collection = Collection.find(params[:id])
    if @collection.request_member_id.present?
      @request_member = Member.find(@collection.request_member_id)
    end
  end

  # 蔵書をもっている人のリスト
  def member_list
    @collections = Collection.where(book_id: params[:id], state: 0)
    if @collections.size == 0
      @message = "在庫がありません。"
    else
      @book = @collections[0].book
      @message = cannot_request
    end


# ＃発送者の評価
    @verygood = []
    @good = []
    @bad = []
    collection = Collection.where(book_id: params[:id], state: 0).first
    member = Member.find(collection.member.id)
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

  # 蔵書の申請フォーム
  def confirm_request
    @message = cannot_request
    return if @message.present?
    @collection = Collection.find_by(id: params[:id], state: 0)
    if @collection.blank?
      @message = "本を申請できません。他の人が申請したか、出品者が出品を取り消した可能性があります。"
    elsif @collection.member_id == session[:id]
      @message = "自分の本に申請できません。"
    end
  end

  # 蔵書の申請
  def request_collection
    @collection = Collection.find_by(id: params[:id], state: 0)

    # 申請可能かチェック
    if @collection.blank?
      @message = "本を申請できません。他の人が申請したか、出品者が出品を取り消した可能性があります。"
    elsif @collection.member_id == session[:id]
      @message = "自分の本に申請できません。"
    end
    @message = cannot_request
    if @message.present?
      render action: :confirm_request
      return
    end

    # ラベルPDFファイルのチェック
    file = params[:data]
    if file.nil? || file.size == 0
      @upload_error = "ファイルがアップロードされていません。"
    elsif File.extname(file.original_filename).downcase != ".pdf"
      @upload_error = "PDFファイルではありません。ファイルを確認してください。"
    elsif file.size > 1.megabyte
      @upload_error = "ファイルサイズが大きすぎます。ファイルを確認してください。"
    else

      # 交換申請処理
      @collection.request_member_id = session[:id]
      @collection.request_date = DateTime.now
      @collection.label = file.read
      @collection.state = 1
      if @collection.save

        # メッセージの作成
        message = Message.new(member_id: @collection.member_id, notice_date: DateTime.now, title: "本の申請依頼がありました。",
          content: "あなたへ『" + @collection.book.title + "』の申請がありました。<a href=\"/collections/" + @collection.id.to_s + "\">こちら</a>から本の発送処理をしてください。",
          read_flg: false)
        message.save
      else
        @upload_error = "ファイルのアップロードに失敗しました。"
      end
    end

    if @upload_error.present?
      render action: :confirm_request
    end
  end

  # 宛名ラベルのダウンロード
  def download_label
    @collection = Collection.find(params[:id])
    if @collection.label.present? &&
      (@collection.member_id == session[:id] || @collection.request_member_id == session[:id])
      send_data @collection.label, filename: "label_" + @collection.id.to_s + ".pdf", disposition: :attachment
    else
      render text: "ラベルファイルが見つかりませんでした。"
    end
  end

  # 発送完了処理
  def complete_sending
    collection = Collection.find_by(id: params[:id], member_id: session[:id], state: 1)
    if collection == nil
      @message = "発送処理エラーです。"
      return
    end
    collection.state = 8
    collection.send_date = DateTime.now
    if collection.save!(validate: false)

      # 発送者のブクを増やす
      # member = Member.find(collection.member_id)
      # member.point = member.point + 1
      # member.save!(validate: false)
      # session[:point] = collection.member.point

      # # 受取者のブクを減らす
      # request_member = Member.find(collection.request_member_id)
      # request_member.point = request_member.point - 1
      # request_member.save!(validate: false)

      # メッセージの作成
      message = Message.new(member_id: collection.request_member_id, notice_date: DateTime.now, title: "本が発送されました。",
        content: "あなたへ『" + collection.book.title + "』が発送されました。届きましたら必ず本を送ってくれた相手の方を<a href=\"/collections/"  + collection.id.to_s + "/receiver_evaluations/new/" + "\">評価してください。</a>本の詳細は<a href=\"/collections/" + collection.id.to_s + "\">こちら</a>",
        read_flg: false)
      message.save
    else
      @message = "発送処理エラーです。"
    end





  end

  private
  def cannot_request
    date = Date.new(Date.today.year, Date.today.month, 1)
    @monthly_collection = Collection.where("request_member_id = " + session[:id].to_s + " and request_date >= " + date.to_s)
    # TODO 上限数のパラメータ化
    if @monthly_collection.size >= 30
      return "1ヶ月の申請数が上限の" + 30.to_s + "に達したため、今月は申請できません。"
    end
    if session[:point] == 0
      return "ブクが足りないため申請できません。申請するには本を登録してブクを増やしてください。"
    end
    @waiting_collection = Collection.where(request_member_id: session[:id], state: 1)
    if session[:point] - @waiting_collection.size <= 0
      return "申請中が" + @waiting_collection.size.to_s + "件あるため、ブクが足りません。"
    end
    return nil
  end

end
