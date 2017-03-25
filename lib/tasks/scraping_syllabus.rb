
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

hash = Hash.new(0)

# 神学部 神学入門－3 
url = 'https://syllabus.doshisha.ac.jp/html/2016/03/103001003.html'

# 文学 現代哲学（１）
url = 'https://syllabus.doshisha.ac.jp/html/2016/11/111079000.html'

url = 'https://syllabus.doshisha.ac.jp/html/2015/37/137584004.html'

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

table_hash["成績評価基準"].css('tbody > tr > td:nth-child(1)').text

table_hash["成績評価基準"].css('tbody > tr > td:nth-child(2)').text

table_hash["成績評価基準"].css('tbody > tr').each do |tr|
  tag = tr.css('td')[0].text.strip
  p tag
  hash[tag] += 1
end

hash

text_hash

t=table_hash["参考文献"].text

keyword = t.match(/『(.+)』/)[1]

#keyword = "ゼロから始める"
url = "https://www.amazon.co.jp/s/ref=as_li_ss_tl?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&url=search-alias=stripbooks&field-keywords=#{keyword}&rh=n:465392,k:#{keyword}&linkCode=ll2&tag=johshisha-22"


