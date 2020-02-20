class Task < ActiveRecord::Base
  include ActiveModel::Validations
  self.table_name  = 'tasks'
  belongs_to :list

  enum priority: { low: 0, medium: 1, high: 2 }
  enum completion_status: { not_started: 0, in_progress: 1, completed: 2 }

  WHITELISTED_ATTRS = %w(id name priority completion_status recurring recurring_schedule deadline)

  # def as_json(options = nil)
  #   super({ except: [:created_at, :updated_at, :list_id, :user_id] }.merge(options || {}))
  # end
end