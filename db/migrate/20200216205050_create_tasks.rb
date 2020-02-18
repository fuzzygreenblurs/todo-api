class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :list
      t.boolean :completed, null: false
      t.string :body, null: false
      t.timestamps null: false
    end
  end
end
