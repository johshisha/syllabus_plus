class SubjectRelationship < ApplicationRecord
  belongs_to :year_datum
  belongs_to :teacher
  
  validates :year_datum_id, presence: true
  validates :teacher_id, presence: true
  validates :year_datum_id, uniqueness: {:scope => :teacher_id}
end
