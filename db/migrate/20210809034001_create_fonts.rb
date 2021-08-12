class CreateFonts < ActiveRecord::Migration[6.0]
  def change
    create_table :fonts do |t|
      t.integer :number, null: false
      t.integer :style, null: false
      t.integer :version, null: false
      t.text :pixels, array: true
    end
  end
end
