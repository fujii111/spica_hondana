json.array!(@books) do |book|
  json.extract! book, :id, :member_id, :title, :publisher, :author, :language, :sale_date, :height, :width, :depth, :isbn, :description, :image, :delete_flg
  json.url book_url(book, format: :json)
end
