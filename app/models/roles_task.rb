class RolesTask < ActiveRecord::Base
  belongs_to :role
  belongs_to :task
end
