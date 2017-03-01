class CreateYearData < ActiveRecord::Migration[5.0]
  def change
    create_table :year_data do |t|
      t.integer :year, null: false
      t.integer :term, null: false
      t.text :url, unique: true
      t.integer :number_of_students
      t.float :A
      t.float :B
      t.float :C
      t.float :D
      t.float :F
      t.float :other
      t.float :mean_score
      t.references :subject, foreign_key: true

      t.timestamps
    end
    add_index :year_data, :year
    add_index :year_data, :term
    add_index :year_data, :A
    add_index :year_data, :B
    add_index :year_data, :C
    add_index :year_data, :D
    add_index :year_data, :F
    add_index :year_data, :mean_score
  end
end
