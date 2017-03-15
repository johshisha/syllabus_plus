class SummarizedSubject < ApplicationRecord
  belongs_to :faculty
  has_many :year_data, primary_key: "subject_id", foreign_key: "subject_id"
  has_one :teacher
  
  validates :name, presence: true
  validates :code, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :url, uniqueness: true
end
