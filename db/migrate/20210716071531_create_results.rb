class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.references :user, foreign_key: true
      t.references :chart, foreign_key: true
      t.integer :option, null: false
      t.integer :medal
      t.integer :score, null: false
      t.integer :cool
      t.integer :great
      t.integer :good
      t.integer :bad
      t.datetime :played_time
      t.timestamps
    end
  end
end
