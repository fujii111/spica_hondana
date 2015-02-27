require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  setup do
    @member = members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create member" do
    assert_difference('Member.count') do
      post :create, member: { address: @member.address, birthday: @member.birthday, delete_flg: @member.delete_flg, favorite_author1: @member.favorite_author1, favorite_author2: @member.favorite_author2, favorite_author3: @member.favorite_author3, favorite_author4: @member.favorite_author4, favorite_author5: @member.favorite_author5, kana: @member.kana, login_id: @member.login_id, mail_address: @member.mail_address, name: @member.name, nickname: @member.nickname, password: @member.password, point: @member.point, reset_limit: @member.reset_limit, reset_token: @member.reset_token }
    end

    assert_redirected_to member_path(assigns(:member))
  end

  test "should show member" do
    get :show, id: @member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @member
    assert_response :success
  end

  test "should update member" do
    patch :update, id: @member, member: { address: @member.address, birthday: @member.birthday, delete_flg: @member.delete_flg, favorite_author1: @member.favorite_author1, favorite_author2: @member.favorite_author2, favorite_author3: @member.favorite_author3, favorite_author4: @member.favorite_author4, favorite_author5: @member.favorite_author5, kana: @member.kana, login_id: @member.login_id, mail_address: @member.mail_address, name: @member.name, nickname: @member.nickname, password: @member.password, point: @member.point, reset_limit: @member.reset_limit, reset_token: @member.reset_token }
    assert_redirected_to member_path(assigns(:member))
  end

  test "should destroy member" do
    assert_difference('Member.count', -1) do
      delete :destroy, id: @member
    end

    assert_redirected_to members_path
  end
end
