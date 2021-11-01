class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.text :message
      t.integer :category
      t.boolean :no_reply

      t.timestamps
    end
  end
end
