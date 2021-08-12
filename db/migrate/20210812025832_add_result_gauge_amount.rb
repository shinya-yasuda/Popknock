class AddResultGaugeAmount < ActiveRecord::Migration[6.0]
  def change
    add_column :results, :gauge_amount, :integer
    add_column :results, :gauge_option, :integer
    rename_table :fonts, :materials
    rename_column :results, :option, :random_option
  end
end
