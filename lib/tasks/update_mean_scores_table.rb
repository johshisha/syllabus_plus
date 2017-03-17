#coding: utf-8

require "#{Rails.root}/app/models/subject"
require "#{Rails.root}/app/models/year_datum"
require "#{Rails.root}/app/models/faculty"

class BatchUpdateMeanScore
  def self.calculate_data(year_data)
    max_year = year_data.map(&:year).max
    count = 0.0
    decay = 0.3
    sums = {A:0.0, B:0.0, C:0.0, D:0.0, F:0.0, other:0.0, mean_score:0.0, number_of_students: 0}
    weighted = {weighted_sum_score:0.0, weighted_count:0.0}
    year_data.each do |year_datum|
      if year_datum.mean_score
        sums[:A] += year_datum.A
        sums[:B] += year_datum.B
        sums[:C] += year_datum.C
        sums[:D] += year_datum.D
        sums[:F] += year_datum.F
        sums[:other] += year_datum.other
        sums[:mean_score] += year_datum.mean_score
        sums[:number_of_students] += year_datum.number_of_students
        count += 1.0
        weight = 1 - (max_year - year_datum.year) * decay
        weighted[:weighted_sum_score] += year_datum.mean_score * weight
        weighted[:weighted_count] += weight
      end
    end
    sums.map { |key, value| sums[key] = count != 0.0 ? value/count : 0.0 }
    sums[:weighted_score] = count != 0.0 ? weighted[:weighted_sum_score] / weighted[:weighted_count] : nil
    sums
  end
    
  def self.execute
    p "#{DateTime.now}, Start BatchUpdateMeanScore"
    before = SubjectScore.count
    faculties = Faculty.all
    faculties.each do |faculty|
      subjects = faculty.subjects
      subjects.each do |subject|
        ret = calculate_data(subject.year_data)
        if subject_score = SubjectScore.find_by(subject_id: subject.id)
          subject_score.update(subject_id: subject.id, A: ret[:A], B: ret[:B], C: ret[:C], D: ret[:D], F: ret[:F], other: ret[:other], number_of_students: ret[:number_of_students].to_i, mean_score: ret[:mean_score], weighted_score: ret[:weighted_score])
        else
          SubjectScore.create(subject_id: subject.id, A: ret[:A], B: ret[:B], C: ret[:C], D: ret[:D], F: ret[:F], other: ret[:other], number_of_students: ret[:number_of_students].to_i, mean_score: ret[:mean_score], weighted_score: ret[:weighted_score])
        end
      end
    end
    p "updated #{SubjectScore.count - before} subjects"
    p "#{DateTime.now}, Finish BatchUpdateMeanScore"
  end
end

if __FILE__ == $0
  BatchUpdateMeanScore.execute
end
