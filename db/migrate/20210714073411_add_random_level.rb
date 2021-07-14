class AddRandomLevel < ActiveRecord::Migration[6.0]
  def change
    add_column :charts, :ran_level, :integer
    add_column :charts, :s_ran_level, :integer
  end
end
