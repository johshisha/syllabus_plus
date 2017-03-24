#coding: utf-8
require 'pry'

require "#{Rails.root}/app/models/subject"
require "#{Rails.root}/app/models/faculty"
require "#{Rails.root}/app/models/subject_score"
require "#{Rails.root}/app/models/summarized_subject"

class BatchCreateFaculties
  def self.retrieve_faculties_from_duet
    agent = Mechanize.new
    url = 'https://duet.doshisha.ac.jp/kokai/html/fi/fi020/FI02001G.html'
    page = agent.get(url)
    table = page.css('#form1 > div > div > table')
    table.css('tr')[1].css('td')[1].css('select > option').each do |opt|
      name =  opt.text
      p "#{name}: #{opt.attr('value')}"
      faculty = Faculty.find_by(name: name)
      if faculty
        faculty.update_attribute(:code, opt.attr("value"))
      else
        faculty = Faculty.create(name: name, code: opt.attr("value"))
      end
    end
  end
  def self.retrieve_faculties_from_syllabus
    agent = Mechanize.new
    url = "https://syllabus.doshisha.ac.jp/"
    page = agent.get(url)
    page.css('body > table:nth-child(4) > tbody > tr > td > form > table:nth-child(7) > tbody > tr:nth-child(5) > td > select > option').each do |opt|
      name = opt.text.split('/')[0].strip
      if name == "グローバル・コミュニケーション学部"
        name = name
      elsif name == '全学共通教養教育科目（外国語教育科目・保健体育科目以外）'
        name = name
      elsif name == '日本語・日本文化教育科目'
        name = name
      else
        name = name.split(/[・|･]/)[0].strip
      end
      p "(code: #{opt.attribute('value').text}, name: #{name})" if opt.has_attribute?('value')
      faculty = Faculty.find_by(name: name)
      if faculty
        faculty.update_attribute(:syllabus_code, opt.attribute('value').text)
      end
    end
  end
  def self.execute()
    p "#{DateTime.now}, Start BatchCreateFaculties"
    retrieve_faculties_from_duet
    retrieve_faculties_from_syllabus
    p "#{DateTime.now}, Finish BatchCreateFaculties"
  end
end

if __FILE__ == $0
  BatchCreateFaculties.execute
end
