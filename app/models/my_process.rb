# encoding: utf-8
class MyProcess < ActiveRecord::Base
  belongs_to :process_type
  belongs_to :user

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  
  has_many :tasks, dependent: :destroy
  has_many :messages, dependent: :destroy

  after_create :send_start_message

  validates :process_type, :user, :address, presence: true

  def self.visibles_for(user)
    uid = user.id
    condition = "process_types.user_id = ? OR my_processes.user_id = ? OR tasks.user_id = ? OR tasks.responsible_user_id = ?"
    MyProcess.joins(:process_type).joins("LEFT JOIN tasks ON 'my_process.id' = 'tasks.my_process_id'").where(condition, uid, uid, uid, uid)
  end

  def to_s
    return "[#{id}]: #{process_type.to_s} - #{user.to_s} - #{address} - #{starts_at.strftime('%d/%m/%Y %H:%M')}"
  end

  def hashtag
    "#{process_type.hashtag}_#{id}"
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
        content: "#{task.id}: #{task.waitings_to_s} #{task.name}"
      }
    end
  end

  def twitter_status_url
    "https://twitter.com/search?q=%23#{hashtag}&src=typd"
  end

  private 
    def send_start_message
      Message.create(
        sender: user, 
        receiver: process_type.user, 
        my_process: self,
        message: "@#{process_type.user.username} quiero ##{hashtag} el día #{starts_at.day} de #{starts_at.strftime('%b')} a las #{starts_at.strftime("%H:%M")} en #{address}"[0..139],
        custom: true)
    end
end
