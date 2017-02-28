class Teacher < ApplicationRecord
  has_many :subject_relationships, dependent: :destroy
  has_many :year_data, through: :subject_relationships
end
