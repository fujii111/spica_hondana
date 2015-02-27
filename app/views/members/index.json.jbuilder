json.array!(@members) do |member|
  json.extract! member, :id, :login_id, :password, :reset_token, :reset_limit, :name, :kana, :nickname, :birthday, :mail_address, :address, :point, :favorite_author1, :favorite_author2, :favorite_author3, :favorite_author4, :favorite_author5, :delete_flg
  json.url member_url(member, format: :json)
end
