class Task < ActiveRecord::Base
  attr_accessor :dont_validate_start_and_end

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
  before_validation :assign_start_and_end, if: Proc.new{ |task| task.assigned_end.blank? }

  validates :name, presence: true

  scope :sorted_by_assigned_start, -> { all.sort {|t1, t2| t1.assigned_start <=> t2.assigned_start} }

  after_save :rearrange_waiting_tasks

  #validate :assigned_start_with_waitings, unless: Proc.new{ |task| task.dont_validate_start_and_end == true }
  #validate :assigned_end_with_waitings, unless: Proc.new{ |task| task.dont_validate_start_and_end == true }

  # def assigned_start_with_waitings
  #   if self.assigned_start < min_assigned_start
  #     errors[:assigned_start] << "Invalid date"
  #   end
  # end

  # def assigned_end_with_waitings
  #   if self.assigned_end > max_assigned_end
  #     errors[:assigned_end] << "Invalid date"
  #   end
  # end

  def rearrange_waiting_tasks
    waitings = Waiting.where(waiting_id: id)
    waitings.each do |waiting|
      waiting.rearrange_tasks
    end
  end

  def relative_id
    sorted = my_process.tasks.sort {|t1, t2| t1.assigned_start <=> t2.assigned_start}
    sorted.map(&:id).index(self.id)+1
  end

  def to_s
    return "#{name} - id: #{id}"
  end

  def location
    return {lat: latitude, lng: longitude, title: address, task_id: id}
  end

  def waitings_to_s
    if waiting_for_tasks.any?
      names = waiting_for_tasks.map{ |task| task.name }
      pluralized_names = (names.length >= 2) ?  ": [#{names.join(', ')}]" : " #{names.first}"
      ", waiting for#{pluralized_names}"
    end
  end

  def assign_start_and_end
    self.assigned_start = DateTime.now
    self.assigned_end = DateTime.now+1.hour
  end

  def min_assigned_start
    if waiting_for_tasks.empty?
      assigned_start
    else
      waiting_for_tasks.map{ |task| task.assigned_end }.sort.last
    end
  end

  def max_assigned_end
    if tasks_waiting.empty?
      DateTime.now + 2.weeks
    else
      tasks_waiting.map{ |task| task.assigned_start }.sort.last
    end
  end

  def self.waiting_for_tasks_ids(task, ids)
    waitings = Waiting.where(task: task)

    if waitings.any?
      ids += waitings.pluck :waiting_id
      waitings.each do |waiting|
        ids += self.waiting_for_tasks_ids(waiting.waiting, ids)
      end
    end

    return ids.uniq
  end

  def self.waiting_tasks_ids(task, ids)
    waitings = Waiting.where(waiting_id: task)

    if waitings.any?
      ids += waitings.pluck :task_id
      waitings.each do |waiting|
        ids += self.waiting_tasks_ids(waiting.task, ids)
      end
    end

    return ids.uniq
  end

  def can_wait_for
    my_process.tasks.where.not(id: Task.waiting_tasks_ids(self, [])+[self.id])
  end
end
