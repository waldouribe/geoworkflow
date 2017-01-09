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

  validates :name, presence: true

  scope :sorted_by_current_start, -> { all.sort {|t1, t2| t1.current_start <=> t2.current_start} }

  def relative_id
    sorted = my_process.tasks.sort {|t1, t2| t1.current_start <=> t2.current_start}
    sorted.map(&:id).index(self.id)+1
  end

  def to_s
    return description.first(100)
  end

  def location
    return {lat: latitude, lng: longitude, title: address}
  end

  def waitings_to_s
    # if waiting_for_tasks.any?
    #   "[(#{waiting_for_tasks.pluck(:id).join(", ")}) -> #{self.id}]"
    # elsif tasks_waiting.any?
    #   "[#{self.id}->(#{tasks_waiting.pluck(:id).join(", ")})]"
    # end
    if waiting_for_tasks.any?
      relative_ids = waiting_for_tasks.map{ |task| task.relative_id }.join(", ")
      " | waiting for: [#{relative_ids}]"
    end
  end

  def current_start
    return assigned_start || created_at
  end

  def current_end
    return assigned_end || created_at + 1.hour
  end

  def starts_at
    return DateTime.now()
  end

  def ends_at
    DateTime.now()+1.hour
  end
end
