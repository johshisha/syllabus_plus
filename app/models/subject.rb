class Subject < ApplicationRecord
  belongs_to :faculty
  has_many :year_data, dependent: :destroy
  has_one :subject_score
  has_many :stocked_logs
  
  validates :name, presence: true
  validates :code, presence: true, length: { maximum: 50 }, uniqueness: true
end
