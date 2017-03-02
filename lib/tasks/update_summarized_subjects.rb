#coding: utf-8

require "#{Rails.root}/app/models/subject"
require "#{Rails.root}/app/models/faculty"
require "#{Rails.root}/app/models/subject_score"
require "#{Rails.root}/app/models/summarized_subject"

class BatchUpdateSummarizedSubject    
  def self.execute(year)
    p "#{DateTime.now}, Start BatchUpdateSummarizedSubject"
    faculties = Faculty.all
    faculties.each do |faculty|
      subjects = faculty.subjects.includes(:subject_score)
      subjects.each do |subject|
        year_datum = subject.year_data[0]
        new_url = year_datum ? year_datum.url.gsub(year_datum.year.to_s,  year.to_s) : nil
        term = year_datum ? year_datum.term : nil
        score = subject.subject_score
        if summarized_subject = SummarizedSubject.find_by(subject_id: subject.id)
          summarized_subject.update(name: subject.name, code: subject.code, url: new_url, term: term, subject_id: subject.id, faculty_id: faculty.id, A: score.A, B: score.B, C: score.C, D: score.D, F: score.F, other: score.other, number_of_students: score.number_of_students, mean_score: score.mean_score, weighted_score: score.weighted_score)
        else
          SummarizedSubject.create(name: subject.name, code: subject.code, url: new_url, term: term, subject_id: subject.id, faculty_id: faculty.id, A: score.A, B: score.B, C: score.C, D: score.D, F: score.F, other: score.other, number_of_students: score.number_of_students, mean_score: score.mean_score, weighted_score: score.weighted_score)
        end
      end
    end
    p "#{DateTime.now}, Finish BatchUpdateSummarizedSubject"
  end
end

year = ARGV[0]
BatchUpdateSummarizedSubject.execute year
