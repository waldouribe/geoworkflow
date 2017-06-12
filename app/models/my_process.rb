# encoding: utf-8
class MyProcess < ActiveRecord::Base
  belongs_to :user

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  
  has_many :tasks, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :user, :name, :hashtag, presence: true

  accepts_nested_attributes_for :tasks

  def self.visibles_for(user)
    if user.role? :admin
      return MyProcess.all
    else
      MyProcess.joins(:tasks).where('tasks.responsible_user_id' => user.id).uniq
    end
  end

  def to_s
    return "[#{id}]: #{name} - #{user.to_s}"
  end

  def location
    return {lat: latitude, lng: longitude, title: address}
  end

  def tasks_locations
    return tasks.map{|t| t.location }
  end

  def tasks_center
    geolocated_tasks = tasks.where("latitude IS NOT NULL")
    lat_sum = geolocated_tasks.map{ |t| t.latitude }.inject(:+)
    lng_sum = geolocated_tasks.map{ |t| t.longitude }.inject(:+)
    
    if lat_sum.nil?
      
      return {lat: -33.4378305, lng: -70.65044920000003}
    else
      return {lat: lat_sum/geolocated_tasks.count, lng: lng_sum/geolocated_tasks.count}
    end
  end

  def tasks_timeline
    tasks.order("assigned_start ASC").map do |task| {
        start: task.assigned_start,
        end: task.assigned_end,
        id: task.id,
        content: "#{task.name} #{task.waitings_to_s}"
      }
    end
  end

  def twitter_status_url
    "https://twitter.com/search?q=%23#{hashtag}&src=typd"
  end
end
