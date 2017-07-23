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

  has_and_belongs_to_many :roles

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  before_create :assign_start_and_end

  validates :name, presence: true
  validates :priority, numericality: { greater_than_or_equal_to: 1 }

  scope :sorted_by_assigned_start, -> { all.sort {|t1, t2| t1.assigned_start <=> t2.assigned_start} }

  before_save :rearrange_waiting_tasks

  def self.order_by(tasks, params)
    case params[:order]
      when "distance"
        location = Geocoder.search(params[:ip])
        lat = location[0].data['latitude']
        long = location[0].data['longitude']
        ans = []

        tasks.each do |task|
          the_closest = Task.closest(tasks, lat, long)
          ans << the_closest
          tasks = tasks.where("id != ?", the_closest.id)
        end
        return ans
      when "priority"
        return tasks.order("priority ASC")
      when "assigned_start"
        return tasks.order("assigned_start ASC")
      else
        return tasks.order("assigned_start ASC")
    end
  end

  def self.closest(tasks, lat, long)
    min = nil
    closest = nil
    tasks.each do |task|
      distance = Math.sqrt((task.latitude-lat.to_f)**2 + (task.longitude-long.to_f)**2)
      if !min or distance < min
        closest = task
        min = distance
      end
    end

    puts "-----> #{closest.name} #{closest.latitude.round(3)}, #{closest.longitude.round(3)}, distance: #{distance}"

    return closest
  end

  def rearrange_waiting_tasks
    waitings = Waiting.where(waiting_id: id)
    waitings.each do |waiting|
      waiting.rearrange_tasks
    end
    if self.waiting_for_tasks.empty?
      self.assign_start_and_end
    end
  end

  def relative_id
    sorted = my_process.tasks.sort {|t1, t2| t1.assigned_start <=> t2.assigned_start}
    sorted.map(&:id).index(self.id)+1
  end

  def status
    if actual_start.blank?
      return 'not-started'
    elsif actual_end.present?
      return 'ended'
    else
      return 'in-progress'
    end
  end

  def to_s
    prefix = "<b>#{responsible_user || '@ ?'}</b> <small>must </small><b>#{name}</b> <small>at</small> <b>#{address}</b>"
    waiting_for = waiting_for_tasks.any? ? " <small>when</small> <b>#{waiting_for_tasks.map{|task| task.name}.join(', ')}</b> <small>finishes</small>" : ''
    return prefix+waiting_for
  end

  def doable?(user)
    waiting_for_tasks.where('tasks.actual_end IS NULL').blank? and (actual_start.nil? or responsible_user == user)
  end


  def location
    return {lat: latitude, lng: longitude, title: "#{name} at #{address}", task_id: id}
  end

  def waitings_to_s
    if waiting_for_tasks.any?
      names = waiting_for_tasks.map{ |task| task.name }
      pluralized_names = (names.length >= 2) ?  ": [#{names.join(', ')}]" : " #{names.first}"
      ", when #{pluralized_names} finishes"
    end
  end

  def assign_start_and_end
    oldest_task = self.my_process.tasks.order("assigned_start ASC").first
    if oldest_task.present?
      self.assigned_start = oldest_task.assigned_start
      self.assigned_end = oldest_task.assigned_end
    else
      self.assigned_start = DateTime.now
      self.assigned_end = DateTime.now+1.hour
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

  def visible_for(user)
    return (user.role?(:admin) or self.roles.empty? or (self.roles.pluck(:name) & user.roles.pluck(:name)).any?)
  end

  def self.visibles_for(user)
    if user.role == 'admin'
      self.all
    else
      Task.joins('LEFT JOIN roles_tasks ON tasks.id = roles_tasks.task_id')
      .where('roles_tasks.task_id IS NULL OR roles_tasks.role_id IN (?)', user.roles.pluck(:id))
      .uniq
    end
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
