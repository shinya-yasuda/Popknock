class AddMusicId < ActiveRecord::Migration[6.0]
  def change
    add_reference :charts, :music, foreign_key: true, null: false
  end
end
