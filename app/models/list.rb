class List < ActiveRecord::Base
    include ActiveModel::Validations

    self.table_name  = 'lists'
    belongs_to :user
    has_many :tasks

    before_create :generate_tasks
    validates :title,  presence: true, length: { maximum: 100 }

    attr_accessor :user_id, :tasks

    def assign(attrs)
        attrs.each { |attr, value| instance_variable_set(attr, value) }
    end

    def generate_tasks
        puts "gets here"
    end
end
