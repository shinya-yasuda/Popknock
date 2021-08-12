class RemoveResultColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :results, :cool, :integer
    remove_column :results, :great, :integer
    remove_column :results, :played_time, :datetime
  end
end
