class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  # GET /members
  def index
    @members = Member.where(delete_flg: false)
  end

  # GET /members/1
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  def create
    @member = Member.new(member_params)
    @member.point = 0
    @member.delete_flg = false

    if @member.save
      redirect_to @member, notice: '会員情報を登録しました。'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
      redirect_to @member, notice: 'プロフィールを変更しました。'
    else
      render action: 'edit'
    end
  end

  # DELETE /members/1
  def destroy
    @member.delete_flg = true
    @member.save
    redirect_to members_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id], :conditions => {:delete_flg => false})
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(:login_id, :password, :password_confirmation, :name, :kana, :nickname, :birthday, :mail_address, :address, :favorite_author1, :favorite_author2, :favorite_author3, :favorite_author4, :favorite_author5)
  end
end
