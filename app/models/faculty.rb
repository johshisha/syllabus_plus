class Faculty < ApplicationRecord
  has_many :subjects, dependent: :destroy
end
