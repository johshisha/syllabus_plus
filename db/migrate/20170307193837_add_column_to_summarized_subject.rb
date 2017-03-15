class AddColumnToSummarizedSubject < ActiveRecord::Migration[5.0]
  def change
    add_column :summarized_subjects, :place, :integer
    add_column :summarized_subjects, :credit, :integer
    add_column :summarized_subjects, :teacher_id, :integer
  end
end
