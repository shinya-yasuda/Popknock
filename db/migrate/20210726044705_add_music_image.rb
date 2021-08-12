class AddMusicImage < ActiveRecord::Migration[6.0]
  def change
    add_column :musics, :pixels, :text, array: true
  end
end
