class Task < ActiveRecord::Base
    self.table_name  = 'tasks'
    belongs_to :list
end
