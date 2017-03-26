class SyllabusDatum < ApplicationRecord
  belongs_to :subject
  
  validates :subject_id, presence: true
  validates :tag, presence: true
  validates :value, presence: true
  validates :subject_id, uniqueness: {:scope => [:tag, :category, :value]}
end
