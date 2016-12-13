json.array!(@my_processes) do |my_process|
  json.extract! my_process, :id, :process_type_id, :user_id, :address, :latitude, :longitude, :starts_at
  json.url my_process_url(my_process, format: :json)
end
