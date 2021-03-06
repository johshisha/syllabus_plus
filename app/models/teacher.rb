class Teacher < ApplicationRecord
  has_many :subject_relationships, dependent: :destroy
  has_many :year_data, through: :subject_relationships
  has_one :summarized_subject
  
  validates :name, presence: true, uniqueness: true
end
