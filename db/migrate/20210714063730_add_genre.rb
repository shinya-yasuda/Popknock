class AddGenre < ActiveRecord::Migration[6.0]
  def change
    add_column :musics, :genre, :string
  end
end
