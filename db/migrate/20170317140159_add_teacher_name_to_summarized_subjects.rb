class AddTeacherNameToSummarizedSubjects < ActiveRecord::Migration[5.0]
  def change
    add_column :summarized_subjects, :teacher_name, :string
  end
end
