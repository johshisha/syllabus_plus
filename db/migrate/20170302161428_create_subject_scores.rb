class CreateSubjectScores < ActiveRecord::Migration[5.0]
  def change
    create_table :subject_scores do |t|
      t.references :subject, foreign_key: true, unique: true
      t.float :A
      t.float :B
      t.float :C
      t.float :D
      t.float :F
      t.float :other
      t.float :mean_score
      t.float :weighted_score

      t.timestamps
    end
    add_index :subject_scores, :A
    add_index :subject_scores, :B
    add_index :subject_scores, :C
    add_index :subject_scores, :D
    add_index :subject_scores, :F
    add_index :subject_scores, :mean_score
    add_index :subject_scores, :weighted_score
  end
end
