class AddIndexToSummarizedSubject < ActiveRecord::Migration[5.0]
  def change
    add_index :summarized_subjects, :teacher_name
    add_index :summarized_subjects, :place
    add_index :summarized_subjects, :term
  end
end
