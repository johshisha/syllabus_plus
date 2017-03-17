class AddColumnToStockedLog < ActiveRecord::Migration[5.0]
  def change
    add_column :stocked_logs, :deleted, :boolean, default: false
  end
end
