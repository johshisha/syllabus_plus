
FileUtils.cd '../../'
require './config/boot'
APP_PATH  = File.expand_path('config/application') unless defined?(APP_PATH)
require APP_PATH
Rails.application.require_environment!

require "#{Rails.root}/app/models/subject"
require "#{Rails.root}/app/models/year_datum"
require "#{Rails.root}/app/models/faculty"
require "#{Rails.root}/app/models/subject_score"
require "#{Rails.root}/app/models/summarized_subject"

require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'robotex'

url = 'https://syllabus.doshisha.ac.jp/html/2016/G1/1G1111000.html'

agent = Mechanize.new
robotex = Robotex.new
p "robots: #{robotex.allowed?(url)}"
page = agent.get(url)
''

data = page.css('body > div > table:nth-child(2) > tbody > tr:nth-child(4) > td')
children=data.children
''

table_hash = {}
text_hash = {}
tag = 'init'

children.each do |t|
  text = t.text.strip
  if t.node_name == 'table'
    table_hash[tag] = t
  elsif text.present?
    if ret = text.match(/^＜(.+)＞$/)
      p "tag #{tag = ret[1]}"
    else
      text_hash[tag] = text
    end
  end
end
''
table_hash.keys

table_hash["テキスト"]

text_hash

t=table_hash["参考文献"].text

t.match(/『(.+)』/)[1]

from_syllabus = '978-4798032627'

from_amazon = '978-4798032627'

from_syllabus == from_amazon


