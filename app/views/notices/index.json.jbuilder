json.array!(@notices) do |notice|
  json.extract! notice, :id, :content, :notice_date
  json.url notice_url(notice, format: :json)
end
