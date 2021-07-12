class AddInformations < ActiveRecord::Migration[6.0]
  def change
    create_table :informations do |t|
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
