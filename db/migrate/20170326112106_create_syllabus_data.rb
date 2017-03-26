class CreateSyllabusData < ActiveRecord::Migration[5.0]
  def change
    create_table :syllabus_data do |t|
      t.references :subject, foreign_key: true
      t.string :tag
      t.string :category
      t.string :value

      t.timestamps
    end
    add_index :syllabus_data, [:subject_id, :tag]
  end
end
