class SubjectScore < ApplicationRecord
  belongs_to :subject
  
  validates :subject_id, presence: true
end
