class CreateFaculties < ActiveRecord::Migration[5.0]
  def change
    create_table :faculties do |t|
      t.string :name, null: false, unique: true
      t.string :code, null: false, unique: true

      t.timestamps
    end
  end
end
