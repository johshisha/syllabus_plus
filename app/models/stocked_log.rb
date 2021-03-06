class StockedLog < ApplicationRecord
  belongs_to :summarized_subject, primary_key: "subject_id", foreign_key: "subject_id"
  belongs_to :subject
  
  before_save :array2str_periods
  
  validates :uuid, presence: true, length: { maximum: 50 }
  validates :subject_id, presence: true
  validates :week, presence: true
  validates :periods, presence: true
  validates :uuid, uniqueness: { :scope => [:subject_id] }
  
  private
    def array2str_periods
      self.periods = periods.gsub(/[\[|\]| |"]/, '')
    end
end
