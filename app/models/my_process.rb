class MyProcess < ActiveRecord::Base
  belongs_to :process_type
  belongs_to :user

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  
  has_many :tasks, dependent: :destroy

  def to_s
    return "[#{id}]: #{process_type.to_s} - #{user.to_s} - #{address} - #{starts_at.strftime('%d/%m/%Y %H:%M')}"
  end

  def location
    return {lat: latitude, lng: longitude, title: address}
  end

  def tasks_locations
    return tasks.map{|t| t.location }
  end

  def tasks_center
    lat_sum = tasks.map{ |t| t.latitude }.inject(:+)
    lng_sum = tasks.map{ |t| t.longitude }.inject(:+)
    return {lat: lat_sum/tasks.count, lng: lng_sum/tasks.count}
  end

  def tasks_timeline
    return tasks.map do |task|
      {
        start: task.starts_at,
        end: task.ends_at,
        id: task.id,
        content: "#{task.id} - #{task.name}"
      }
    end
  end
end
