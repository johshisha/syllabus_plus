class YearDatum < ApplicationRecord
  belongs_to :subject
  has_many :subject_relationships, dependent: :destroy
  has_many :teachers, through: :subject_relationships
end
