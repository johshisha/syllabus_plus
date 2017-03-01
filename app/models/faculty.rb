class Faculty < ApplicationRecord
  has_many :subjects, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :code, presence: true, length: { maximum: 50 }, uniqueness: true
end
