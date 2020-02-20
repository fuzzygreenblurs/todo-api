class List < ActiveRecord::Base
  include ActiveModel::Validations
  self.table_name  = 'lists'
  belongs_to :user
  has_many :tasks, dependent: :destroy

  WHITELISTED_OPTIONAL_PARAMS = %w(tasks)

  def as_json(options = nil)
    super({ only: [:id, :title] }.merge(options || {}))
  end

  def assign_tasks(incoming_tasks=[])
    incoming_tasks.each do |task_data|
      # no rescue needed for update
      task = Task.new(list: self)
      task.update(task_data)
    end
  end
end