class CreateBudgets < ActiveRecord::Migration[8.1]
  def change
    create_table :budgets do |t|
      t.string :code
      t.string :workshop_name
      t.decimal :total_value, precision: 10, scale: 2
      t.string :status

      t.timestamps
    end
  end
end
