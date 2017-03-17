class CreateStockedLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :stocked_logs do |t|
      t.string :uuid, null: false
      t.references :subject, foreign_key: true
      t.integer :week, null: false
      t.string :periods, null: false

      t.timestamps
    end
    add_index :stocked_logs, :uuid
    add_index :stocked_logs, :week
    add_index :stocked_logs, :periods
  end
end
