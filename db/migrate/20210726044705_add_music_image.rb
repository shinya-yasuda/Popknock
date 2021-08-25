class AddMusicImage < ActiveRecord::Migration[6.0]
  def change
    add_column :musics, :pixels, :integer, array: true
  end
end
