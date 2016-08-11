class Waiting < ActiveRecord::Base
  belongs_to :task
  belongs_to :waiting, class_name: 'Task'
  validates :task, :waiting, presence: true
end
