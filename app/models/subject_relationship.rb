class SubjectRelationship < ApplicationRecord
  belongs_to :year_datum
  belongs_to :teacher
end
