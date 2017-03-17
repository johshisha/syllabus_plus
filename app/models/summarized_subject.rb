class SummarizedSubject < ApplicationRecord
  belongs_to :faculty
  has_many :year_data, primary_key: "subject_id", foreign_key: "subject_id"
  belongs_to :teacher
  has_many :stocked_logs
  
  validates :name, presence: true
  validates :code, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :url, uniqueness: true
end
