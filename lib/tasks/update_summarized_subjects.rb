#coding: utf-8
require 'pry'

require "#{Rails.root}/app/models/subject"
require "#{Rails.root}/app/models/faculty"
require "#{Rails.root}/app/models/subject_score"
require "#{Rails.root}/app/models/summarized_subject"

class BatchUpdateSummarizedSubject
  attr_accessor :post_data
  
  def self.set_post_data
    # example data of 神学部2016
    example = "clicknumber=1&connection=AND&select_bussinessyear=2016&courseid=1&subjectcd=1&subjectcd2=&keyword=&maxdisplaynumber=1000&furiwakeid=&gakuseiid=&key=&gakuseiidflg=0&kohyoflg=&kamokucode="
    post_data = {}
    example.split("&").each do |line|
      l =  line.split('=')
      name, value = l
      post_data.store(name, value)
    end
    """
    # scraping memo
    - 学部変える： subjectcd
    - 年度変える： select_bussinessyear
    - ページ変える： clicknumber (何ページ目か)
    """
    post_data
  end
  
  def self.update_parameter(faculty, year)
    @post_data ||= set_post_data
    hash = {
      'subjectcd': faculty.syllabus_code,
      'select_bussinessyear': year,
    }
    hash.each do |key, val|
      @post_data[key.to_s] = val
    end
  end
  
  def self.retrieve_subjects_of(faculty)
    agent = Mechanize.new
    url = "https://syllabus.doshisha.ac.jp/lectureWebResult.php"
    clicknumber = 1
    trs = []
    loop do
      @post_data['clicknumber'] = clicknumber
      page = agent.post(url, @post_data)
      count = page.css('body > table:nth-child(4) > tbody > tr > td > table > tr').count
      if count.eql? 0
        break
      end
      trs += page.css('body > table:nth-child(4) > tbody > tr > td > table > tr')
      clicknumber += 1
      sleep(1)
    end
    trs
  end
  
  def self.tr2array(tr)
    def self.get_code(data)
      code = data.gsub(/(\xc2\xa0|\s)+/,'').strip
      loop do
        break if code.length == 11
        if code.length == 7
          code += '-'
        end
        code += '0'
      end
      code
    end
    def self.get_name_term(data)
      """
      シラバスに載ってる，一行目（二行目は英語表記）の最後のカッコを除いた部分を名前と定義する
      """
      a=data.to_s.split('>')
      name_pre = a[a.length-2].gsub('<br','')
      term_name = name_pre.end_with?(')') ? name_pre.split(/\(([^\(]*)$/)[0] : name_pre
      if term_name.start_with?("○")
        name = term_name.gsub('○','')
        term = '春'
      elsif term_name.start_with?("△")
        name = term_name.gsub('△','')
        term = '秋'
      end
      return name, ApplicationController.helpers.term2int(term)
    end
    tds = tr.css('td')
    p "invalid data #{tds}" if tds.length != 7
    teachers = tds[3].children.map {|x| x.text.gsub(/(\xc2\xa0)+/, "").gsub('𠮷','吉') if x.text != ""}.compact.map(&:strip).map {|name| ApplicationController.helpers.convert_to_en(name).gsub(/ +/, ' ').strip}
    url = tds[2].css('a').attr('href').text.gsub('../', 'https://syllabus.doshisha.ac.jp/')
    name, term = get_name_term(tds[2].css('a'))
    name = ApplicationController.helpers.convert_to_en name
    code = get_code(tds[0].text)
    place = ApplicationController.helpers.place2int tds[4].text.strip.gsub(/(\xc2\xa0|\s)+/, "")
    credit = tds[5].text.gsub(/(\xc2\xa0|\s|単位)+/,'').to_i
    return name, code, url, term, place, credit, teachers
  end
  
  def self.update_tables(trs, faculty_id)
    before_count = SummarizedSubject.count
    trs.each do |tr|
      name, code, url, term, place, credit, teachers= tr2array(tr)
      if subject = Subject.find_by(code: code)
        subject.update(name: name, code: code, faculty_id: faculty_id)
      else
        subject = Subject.create(name: name, code: code, faculty_id: faculty_id)
        p "create subject (#{subject.name}) in Faculty(#{faculty_id})" if subject.valid?
      end
      
      score = subject.subject_score || SubjectScore.new(A: 0, B: 0, C: 0, D: 0, F: 0, mean_score: 0, other: 0)
      begin
        teacher = Teacher.find_by(name: teachers[0]) || Teacher.create(name: teachers[0])
        teacher_id = teacher ? teacher.id : nil
      rescue
        binding.pry
      end
      if summarized_subject = SummarizedSubject.find_by(subject_id: subject.id)
        summarized_subject.update(name: subject.name, code: code, url: url, term: term, place: place, credit: credit, teacher_id: teacher_id, teacher_name: teachers[0], subject_id: subject.id, faculty_id: faculty_id, A: score.A, B: score.B, C: score.C, D: score.D, F: score.F, other: score.other, number_of_students: score.number_of_students, mean_score: score.mean_score, weighted_score: score.weighted_score)
      else
        SummarizedSubject.create(name: subject.name, code: code, url: url, term: term, place: place, credit: credit, teacher_id: teacher_id, teacher_name: teachers[0], subject_id: subject.id, faculty_id: faculty_id, A: score.A, B: score.B, C: score.C, D: score.D, F: score.F, other: score.other, number_of_students: score.number_of_students, mean_score: score.mean_score, weighted_score: score.weighted_score)
      end
    end
    after_count = SummarizedSubject.count
    after_count - before_count
  end
  
  def self.execute(year)
    p "#{DateTime.now}, Start BatchUpdateSummarizedSubject"
    faculties = Faculty.all
    faculties.each do |faculty|
      update_parameter(faculty, year)
      trs = retrieve_subjects_of faculty
      if trs.length > 0
        p "id #{faculty.id}"
        SummarizedSubject.delete_all(faculty_id: faculty.id) #reset at once
        updated = update_tables(trs, faculty.id)
        p "updated #{updated} subjects in #{faculty.name}"
      else
        p "cannot retrieval data in #{faculty.name}"
      end
    end
    p "#{DateTime.now}, Finish BatchUpdateSummarizedSubject"
  end
end

if __FILE__ == $0
  year = ARGV[0]
  if year
    BatchUpdateSummarizedSubject.execute year
  else
    p "please set retrieval year"
  end
end
