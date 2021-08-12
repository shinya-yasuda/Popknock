class AddInformation < ActiveRecord::Migration[6.0]
  def change
    create_table :information do |t|
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
