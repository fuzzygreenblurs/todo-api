class List < ActiveRecord::Base
  include ActiveModel::Validations
  self.table_name  = 'lists'
  belongs_to :user
  has_many :tasks, dependent: :destroy

  WHITELISTED_OPTIONAL_PARAMS = %w(tasks)

  def as_json(options = nil)
    super({ only: [:id, :title] }.merge(options || {}))
  end

  # TO_DO: make this method private so that only the owner list can be used
  # as self here. this will block potential changes to other tasks
  def assign_tasks(incoming_tasks=[])
    incoming_tasks.each do |task_data|
      task = Task.find_or_initialize_by(list: self, id: task_data[:id])
      task.update(task_data)
    end
  end
end