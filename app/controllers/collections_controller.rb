class CollectionsController < ApplicationController

  # マイページ
  def index
    @collections = Collection.where("member_id = " + session[:id].to_s + " and state < 8")
      .order(state: :desc, regist_date: :desc)
    @completed_collections = Collection.where(member_id: session[:id], state: 8)
    @favorites = Favorite.where(member_id: session[:id]).order(create_date: :desc)
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
      render action: 'confirm'
    else
      render action: 'new'
    end
  end

  # 蔵書の新規登録
  def create
    collection_params = params.require(:collection).permit(:book_id, :isbn, :condition, :band, :sunburn, :scratch, :cigar, :pet, :mold, :height, :width, :depth, :weight, :line, :broken, :note)
    id = params[:collection][:book_id]
    if params[:collection][:book_id].blank?
      @book = Book.getFromAPIByISBN(params[:collection][:isbn])
      @book.delete_flg = false
      httpClient = HTTPClient.new
      @book.image = httpClient.get_content(@book.image_url)
      unless @book.save
        render action: 'new'
        return
      end
      id = @book.id
    end
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
      render action: 'new'
    end
  end

  # 蔵書の詳細
  def show
    @collection = Collection.find(params[:id])
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
  end

  # 蔵書の交換申請フォーム
  def confirm_request
    @message = cannot_request
    return if @message.present?
    @collection = Collection.find_by(id: params[:id], state: 0)
    if @collection.blank?
      @message = "交換申請できません。他の人が申請したか、出品者が出品を取り消した可能性があります。"
    elsif @collection.member_id == session[:id]
      @message = "自分の蔵書に交換申請できません。"
    end
  end

  # 蔵書の交換申請
  def request_collection
    @collection = Collection.find_by(id: params[:id], state: 0)

    # 申請可能かチェック
    if @collection.blank?
      @message = "交換申請できません。他の人が申請したか、出品者が出品を取り消した可能性があります。"
    elsif @collection.member_id == session[:id]
      @message = "自分の蔵書に交換申請できません。"
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
        message = Message.new(member_id: @collection.member_id, notice_date: DateTime.now, title: "本の交換申請依頼がありました。",
          content: "あなたへ本の交換申請依頼がありました。<a href=\"/collections/" + @collection.id.to_s + "\">こちら</a>から本の発送処理をしてください。",
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

  private
  def cannot_request
    date = Date.new(Date.today.year, Date.today.month, 1)
    @monthly_collection = Collection.where("request_member_id = " + session[:id].to_s + " and request_date >= " + date.to_s)
    # TODO 上限数のパラメータ化
    if @monthly_collection.size >= 30
      return "1ヶ月の申請数が上限の" + 30.to_s + "に達したため、今月は申請できません。"
    end
    if session[:point] == 0
      return "ブクが足りないため申請できません。本を登録してください。"
    end
    @waiting_collection = Collection.where(request_member_id: session[:id], state: 1)
    if session[:point] - @waiting_collection.size <= 0
      return "申請中が" + @waiting_collection.to_s + "件あるため、ブクが足りません。"
    end
    return nil
  end

end
