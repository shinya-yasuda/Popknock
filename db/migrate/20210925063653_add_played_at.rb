class AddPlayedAt < ActiveRecord::Migration[6.0]
  def change
    add_column :results, :played_at, :datetime
  end
end
