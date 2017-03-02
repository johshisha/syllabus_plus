class YearDatum < ApplicationRecord
  belongs_to :subject, class_name: "Subject"
  belongs_to :subject, class_name: "SummarizedSubject"
  has_many :subject_relationships, dependent: :destroy
  has_many :teachers, through: :subject_relationships
  
  validates :subject_id, presence: true
  validates :year, presence: true
  validates :subject_id, uniqueness: {:scope => :year}
  validates :term, presence: true
  validates :url, uniqueness: true
end
