json.array!(@genres) do |genre|
  json.extract! genre, :id, :name, :description, :sort, :delete_flg
  json.url genre_url(genre, format: :json)
end
