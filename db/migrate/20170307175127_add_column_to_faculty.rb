class AddColumnToFaculty < ActiveRecord::Migration[5.0]
  def change
    add_column :faculties, :syllabus_code, :string
  end
end
