#coding: utf-8

require "#{Rails.root}/app/models/subject"
require "#{Rails.root}/app/models/faculty"
require "#{Rails.root}/app/models/subject_score"
require "#{Rails.root}/app/models/summarized_subject"
require "#{Rails.root}/lib/tasks/retrieval_data_from_original_site"

require "pry"

class BatchUpdateSummarizedSubject   
  def self.update_tables(trs)
    before_count = SummarizedSubject.count
    trs.each do |tr|
      year, cource, code, term, subject_name, class_number, students_number, a, b, c, d, f, other, mean_score, teachers, subject_url = BatchUpdateSyllabus.tr2array(tr)
      # p year, cource, code, term, subject_name, class_number, teachers, students_number, a, b, c, d, f, other, mean_score
      subject = Subject.find_by(code: code).includes(:subject_score)
      score = subject.subject_score
      if summarized_subject = SummarizedSubject.find_by(subject_id: subject.id)
        summarized_subject.update(name: subject.name, code: code, url: subject_url, term: term, subject_id: subject.id, faculty_id: faculty.id, A: score.A, B: score.B, C: score.C, D: score.D, F: score.F, other: score.other, number_of_students: score.number_of_students, mean_score: score.mean_score, weighted_score: score.weighted_score)
      else
        SummarizedSubject.create(name: subject.name, code: code, url: subject_url, term: term, subject_id: subject.id, faculty_id: faculty.id, A: score.A, B: score.B, C: score.C, D: score.D, F: score.F, other: score.other, number_of_students: score.number_of_students, mean_score: score.mean_score, weighted_score: score.weighted_score)
      end
    end
    after_count = SummarizedSubject.count
    after_count - before_count
  end
  def self.execute(year)
    p "#{DateTime.now}, Start BatchUpdateSummarizedSubject"
    faculties = Faculty.all
    faculties.each do |faculty|
      p "deleting"
      SummarizedSubject.delete_all(faculty_id: faculty.id) #reset at once
      p "#{faculty.name}"
      BatchUpdateSyllabus.update_parameter(faculty, year)
      trs = BatchUpdateSyllabus.retrieve_subjects_of faculty
      updated = update_tables(trs)
      p "updated #{updated} subjects"
    end
    p "#{DateTime.now}, Finish BatchUpdateSummarizedSubject"
  end
end

if __FILE__ == $0
  year = ARGV[0]
  BatchUpdateSummarizedSubject.execute year
end
