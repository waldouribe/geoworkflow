json.array!(@process_types) do |process_type|
  json.extract! process_type, :id, :user_id, :name_id, :hashtag, :description
  json.url process_type_url(process_type, format: :json)
end
