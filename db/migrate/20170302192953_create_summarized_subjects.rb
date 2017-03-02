class CreateSummarizedSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :summarized_subjects do |t|
      t.string :name
      t.string :code
      t.integer :number_of_students
      t.float :A
      t.float :B
      t.float :C
      t.float :D
      t.float :F
      t.float :other
      t.float :mean_score
      t.float :weighted_score
      t.references :faculty, foreign_key: true
      t.references :subject, foreign_key: true
      t.text :url
      t.integer :term

    end
    add_index :summarized_subjects, :name
    add_index :summarized_subjects, :code
    add_index :summarized_subjects, :A
    add_index :summarized_subjects, :B
    add_index :summarized_subjects, :C
    add_index :summarized_subjects, :D
    add_index :summarized_subjects, :F
    add_index :summarized_subjects, :mean_score
    add_index :summarized_subjects, :weighted_score
    add_index :summarized_subjects, :number_of_students
  end
end
