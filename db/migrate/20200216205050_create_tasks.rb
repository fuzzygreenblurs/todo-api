class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :list
      t.string :name, null: false
      t.integer :priority, default: 0
      t.integer :completion_status, default: 0
      t.datetime :completion_status_updated_at
      t.string :recurring_schedule
      t.datetime :deadline
      t.timestamps null: false
    end
  end
end
