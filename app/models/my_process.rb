# encoding: utf-8
class MyProcess < ActiveRecord::Base
  belongs_to :user

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  
  has_many :tasks, dependent: :destroy
  has_many :messages, dependent: :destroy

  #after_create :send_start_message TODO: Deprecate this

  validates :user, :name, :hashtag, presence: true

  accepts_nested_attributes_for :tasks#, reject_if: lambda { |task| task[:name].blank? }

  def self.visibles_for(user)
    condition = "my_processes.user_id = ? OR tasks.responsible_user_id = ?"
    MyProcess.joins("LEFT JOIN tasks ON 'my_process.id' = 'tasks.my_process_id'").where(condition, user.id, user.id)
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
      return {lat: 30, lng: 30}
    else
      return {lat: lat_sum/geolocated_tasks.count, lng: lng_sum/geolocated_tasks.count}
    end
  end

  def tasks_timeline
    tasks.sorted_by_current_start.map do |task|
      {
        start: task.current_start,
        end: task.current_end,
        id: task.id,
        content: "#{task.relative_id}: #{task.name} #{task.waitings_to_s}"
      }
    end
  end

  def twitter_status_url
    "https://twitter.com/search?q=%23#{hashtag}&src=typd"
  end

  private 
    def send_start_message
      # Message.create(
      #   sender: user, 
      #   receiver: process_type.user, 
      #   my_process: self,
      #   message: "@#{process_type.user.username} quiero ##{hashtag} el día #{starts_at.day} de #{starts_at.strftime('%b')} a las #{starts_at.strftime("%H:%M")} en #{address}"[0..139],
      #   custom: true)
    end
end
