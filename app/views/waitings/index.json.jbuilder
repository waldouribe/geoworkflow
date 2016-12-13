json.array!(@waitings) do |waiting|
  json.extract! waiting, :id, :task_id, :waiting_id
  json.url waiting_url(waiting, format: :json)
end
