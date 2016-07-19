json.array!(@tasks) do |task|
  json.extract! task, :id, :my_process_id, :user_id, :address, :latitude, :longitude, :starts_at, :ends_at, :responsible_user_id
  json.url task_url(task, format: :json)
end
