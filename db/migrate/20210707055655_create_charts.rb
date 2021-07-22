class CreateCharts < ActiveRecord::Migration[6.0]
  def change
    create_table :charts do |t|
      t.integer :level, null: false
      t.integer :difficulty, null: false

      t.timestamps
    end
  end
end
