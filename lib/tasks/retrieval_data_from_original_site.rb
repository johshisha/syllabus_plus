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

class BatchUpdateSyllabus
  attr_accessor :post_data

  def self.set_post_data
    #  神学部2016
    example = "form1%3AselectedIndex=0&form1%3AselectedPage=1&form1%3AtopPosition=0&form1%3AkaikoNendolist=2016&form1%3A_id78=&form1%3A_id82=1&form1%3A_id86=11001&form1%3A_id90=&form1%3A_id92=&form1%3A_id104=&form1%3A_id116=&form1%2Fhtml%2Ffi%2Ffi020%2FFI02001G.html=form1&form1%3A__link_clicked__=form1%3AdoKensaku"
    example = example.gsub('%3A', ':')
    example = example.gsub('%2F', '/')
    post_data = {}
    example.split("&").each do |line|
      l =  line.split('=')
      name, value = l
      post_data.store(name, value)
    end
    """
    # scraping memo
    - 学部変える： form1:_id86
    - 年度変える： form1:kaikoNendolist
    - ページ変える： form1:selectedPage (何ページ目か)
    """
    post_data
  end

  def self.update_parameter(faculty, year)
    @post_data ||= set_post_data
    p "update params"
    hash = {
      'form1:_id86': faculty.code,
      'form1:kaikoNendolist': year,
    }
    hash.each do |key, val|
      @post_data[key.to_s] = val
    end
  end

  def self.retrieve_subjects_of(faculty)
    agent = Mechanize.new
    url = "https://duet.doshisha.ac.jp/kokai/html/fi/fi020/FI02001G.html"
    page_number = 1
    @post_data["form1:__link_clicked__"] = "form1:doKensaku"
    page = agent.post(url) # なぜかpostの前に一旦アクセスしないといけない
    trs = []
    first = nil
    loop do
      @post_data['form1:selectedPage'] = page_number
      if page_number != 1
        @post_data["form1:__link_clicked__"] = "form1:doPage"
      end
      page = agent.post(url, @post_data)
      tr_list = page.css('#form1 > span > div > div > table > tbody > tr')
      if (tr_list[0] && tr_list[0].text).eql?(first)
        break
      end
      first = tr_list[0].text
      trs += tr_list.select.with_index{|e, i| i % 2 == 0}
      page_number += 1
      sleep(1)
    end
    trs
  end

  def self.tr2array(tr)
    tds = tr.css('td')
    p "invalid data #{tds}" if tds.length != 14
    subject_url = tds[13].css('a').attribute('onclick').text.match(/http.*html/)[0]
    teachers = tds[3].children.map {|x| x.text.gsub('𠮷','吉')  if x.text != ""}.compact.map(&:strip).map {|name| ApplicationController.helpers.convert_to_en(name).gsub(/ +/, ' ')}
    code, term, subject_name, _, students_number, a, b, c, d, f, other, mean_score, _, _ = tds.map(&:text).map(&:strip)
    subject_name = ApplicationController.helpers.convert_to_en(subject_name)
    code = code.slice(1..-1)
    return code, term, subject_name, students_number, a, b, c, d, f, other, mean_score, teachers, subject_url
  end

  def self.update_tables(trs, faculty_id, year)
    before_count = Subject.count
    trs.each do |tr|
      code, term, subject_name, students_number, a, b, c, d, f, other, mean_score, teachers, subject_url = tr2array(tr)
      subject = Subject.find_by(code: code) || Subject.create(name: subject_name, code: code, faculty_id: faculty_id)
      year_data = YearDatum.find_by(subject_id: subject.id, year: year) || \
                  YearDatum.create(year: year, term: ApplicationController.helpers.term2int(term), url: subject_url, number_of_students: students_number,
                      A: a, B: b, C: c, D: d, F: f, other: other, mean_score: mean_score, subject_id: subject.id)
      teachers.each do |teacher|
        t = Teacher.find_by(name: teacher) || Teacher.create(name:teacher)
        SubjectRelationship.create(year_datum_id: year_data.id, teacher_id: t.id)
      end
    end
    after_count = Subject.count
    after_count - before_count
  end

  def self.execute(year)
    p "#{DateTime.now}, Start BatchUpdateSyllabus (retrieval year: #{year})"
    faculies = Faculty.all
    faculies.each do |faculty|
      p faculty.name
      update_parameter(faculty, year)
      trs = retrieve_subjects_of faculty
      retrieved = update_tables(trs, faculty.id, year)
      p "retrieved #{retrieved} data"
    end
    p "#{DateTime.now}, Finish BatchUpdateSyllabus"
  end
end

if __FILE__ == $0
  year = ARGV[0]
  BatchUpdateSyllabus.execute year
end
