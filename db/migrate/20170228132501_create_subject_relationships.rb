class CreateSubjectRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :subject_relationships do |t|
      t.integer :year_data_id, null: false
      t.integer :teacher_id, null: false

      t.timestamps
    end
    add_index :subject_relationships, [:year_data_id, :teacher_id], unique: true
  end
end
