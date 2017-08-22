class Waiting < ActiveRecord::Base
  belongs_to :task
  belongs_to :waiting, class_name: 'Task', foreign_key: 'waiting_id'
  validates :task, :waiting, presence: true

  after_create :rearrange_tasks

  def rearrange_tasks
    if waiting.assigned_end > task.assigned_start
      task.assigned_start = waiting.assigned_end
    end
    if (task.assigned_end - task.assigned_start)/60 <= 10
      task.assigned_end = task.assigned_start + 1.hour
    end
    task.dont_validate_start_and_end = true
    task.save
    waitings = Waiting.where(waiting_id: task.id)

    waitings.each do |waiting|
      waiting.rearrange_tasks
    end
  end
end
