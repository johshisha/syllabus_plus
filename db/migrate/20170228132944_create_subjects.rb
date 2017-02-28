class CreateSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :code
      t.references :faculty, foreign_key: true

      t.timestamps
    end
    add_index :subjects, :name
    add_index :subjects, :code
  end
end
