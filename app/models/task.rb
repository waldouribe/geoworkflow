class Task < ActiveRecord::Base
  belongs_to :my_process
  belongs_to :user
  belongs_to :responsible_user, class_name: 'User', foreign_key: 'responsible_user_id'

  has_one :process_type, through: :my_process
  has_many :waitings, class_name: 'Waiting', foreign_key: 'task_id', dependent: :destroy
  has_many :waiting_for_tasks, through: :waitings, source: :waiting

  has_many :dependent_waitings, class_name: 'Waiting', foreign_key: 'waiting_id', dependent: :destroy
  has_many :tasks_waiting, through: :dependent_waitings, source: :task

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :address, :name, :user, :my_process, :responsible_user, presence: true

  def to_s
    return description.first(100)
  end

  def location
    return {lat: latitude, lng: longitude, title: address}
  end

  def waitings_to_s
    if waiting_for_tasks.any?
      "[(#{waiting_for_tasks.pluck(:id).join(", ")}) -> #{self.id}]"
    elsif tasks_waiting.any?
      "[#{self.id}->(#{tasks_waiting.pluck(:id).join(", ")})]"
    end
  end
end
