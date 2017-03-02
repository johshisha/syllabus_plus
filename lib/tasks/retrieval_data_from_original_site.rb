#coding: utf-8
require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'pry'

require "#{Rails.root}/app/models/subject"
require "#{Rails.root}/app/models/year_datum"
require "#{Rails.root}/app/models/teacher"
require "#{Rails.root}/app/models/subject_relationship"
require "#{Rails.root}/app/models/faculty"

def term2int(term)
  term_array = ['春', '秋']
  term_array.index(term)
end

def int2term(num)
  term_array = ['春', '秋']
  term_array[num]
end

class BatchUpdateSyllabus
  attr_accessor :post_data 
  
  def self.retrieve_faculties
    url = "http://duet.doshisha.ac.jp/info/gpaindex.jsp"
    page = @agent.get(url)
    page.css('#select1 > td:nth-child(2) > select > option').each do |opt|
      Faculty.create(code: opt.attribute('value').text, name: opt.text.split('/')[0].strip) if opt.has_attribute?('value')
      # p "(code: #{opt.attribute('value').text}, name: #{opt.text.split('/')[0].strip})" if opt.has_attribute?('value')
    end
  end
  
  def self.set_post_data
    # example data of 神学部2016
    example = "furiwakeid=GP1001&hQueryNo=1&hOffSet=0&pageNo=1&rowCount=50&search_term8=&search_term4=010&search_term4_2=ZZZ&toEmpty4=0&toEmpty0=1&languageCode=ja&search_term2=2016&search_term6=12&gakubuKenkyuka1=010&search_term0="
    post_data = {}
    example.split("&").each do |line|
      l =  line.split('=')
      name, value = l
      post_data.store(name, value)
    end
    """
    # scraping memo
    - 学部変える： search_term4, gakubuKenkyuka1 (search_term4_2は理工だけ0G0)
    - 年度変える： search_term2
    - ページ変える： hOffSet (どこを基準に50件表示するか)
    """
    @post_data = post_data
  end
  
  def self.update_parameter(faculty, year)
    hash = {
      'search_term4': faculty.code,
      'gakubuKenkyuka1': faculty.code,
      'search_term2': year,
      'search_term4_2': faculty.code != '060' ? 'ZZZ' : '0G0',
    }
    hash.each do |key, val|
      @post_data[key.to_s] = val
    end
  end
    
  def self.retrieve_subjects_of(faculty)
    url = "http://duet.doshisha.ac.jp/info/GPA"
    offset = 0
    trs = []
    loop do
      @post_data['hOffSet'] = offset
      page = @agent.post(url, @post_data)
      count = page.css('body > form > div > center > table:nth-child(2) > tr').count
      if count.eql? 1
        break
      end
      trs += page.css('body > form > div > center > table:nth-child(2) > tr').slice(2..-1)
      
      offset += 50
    end
    trs
  end
  
  def self.tr2array(tr)
    tds = tr.css('td')
    p "invalid data #{tds}" if tds.length != 16
    teachers = tds[6].children.map {|x| x.text.gsub("   ", "") if x.text != ""}.compact
    subject_url = tds[4].css('a').attribute('href').text
    year, cource, code, term, subject_name, class_number, _, students_number, a, b, c, d, f, other, mean_score, _ = tds.map(&:text).map(&:strip)
    year, cource, code, term, subject_name, class_number, students_number, a, b, c, d, f, other, mean_score, teachers, subject_url
  end
    
  def self.update_tables(trs, faculty_id)
    before_count = Subject.count
    trs.each do |tr|
      year, cource, code, term, subject_name, class_number, students_number, a, b, c, d, f, other, mean_score, teachers, subject_url = tr2array(tr)
      # p year, cource, code, term, subject_name, class_number, teachers, students_number, a, b, c, d, f, other, mean_score
      subject = Subject.find_by(code: code)
      subject = Subject.create(name: subject_name, code: code, faculty_id: faculty_id) if not subject
      year_data = YearDatum.find_by(subject_id: subject.id, year: year)
      year_data = YearDatum.create(year: year, term: term2int(term), url: subject_url, number_of_students: students_number,
                      A: a, B: b, C: c, D: d, F: f, other: other, mean_score: mean_score, subject_id: subject.id) if not year_data
      teachers.each do |teacher|
        t = Teacher.find_by(name: teacher)
        t = Teacher.create(name:teacher) if not t
        SubjectRelationship.create(year_datum_id: year_data.id, teacher_id: t.id)
      end
    end
    after_count = Subject.count
    after_count - before_count
  end
  
  def self.execute(year)
    p "#{DateTime.now}, Start BatchUpdateSyllabus (retrieval year: #{year})"
    @agent = Mechanize.new
    retrieve_faculties
    set_post_data
    faculies = Faculty.all
    faculies.each do |faculty|
      p faculty.name
      update_parameter(faculty, year)
      trs = retrieve_subjects_of faculty
      update_tables(trs, faculty.id)
      p "retrieved #{retrieved} data"
    end
    p "#{DateTime.now}, Finish BatchUpdateSyllabus"
  end
end

year = ARGV[0]
BatchUpdateSyllabus.execute year
