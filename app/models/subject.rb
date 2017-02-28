class Subject < ApplicationRecord
  belongs_to :faculty
  has_many :year_data, dependent: :destroy
end
