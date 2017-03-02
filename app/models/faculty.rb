class Faculty < ApplicationRecord
  has_many :subjects, dependent: :destroy
  has_many :summarized_subjects
  
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :code, presence: true, length: { maximum: 50 }, uniqueness: true
end
