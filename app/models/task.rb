class Task < ActiveRecord::Base
  include ActiveModel::Validations
  self.table_name  = 'tasks'
  belongs_to :list

  enum priority: { low: 0, medium: 1, high: 2 }
  enum completion_status: { not_started: 0, in_progress: 1, completed: 2 }
end