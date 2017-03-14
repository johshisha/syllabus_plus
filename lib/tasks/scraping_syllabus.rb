
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

text_hash

t=table_hash["参考文献"].text

t.match(/『(.+)』/)[1]

from_syllabus = '978-4798032627'

from_amazon = '978-4798032627'

from_syllabus == from_amazon



"https://www.amazon.co.jp/s/ref=as_li_ss_tl?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&url=search-alias=stripbooks&field-keywords=deep+learning&rh=n:465392,k:deep+learning&linkCode=ll2&tag=johshisha-22&linkId=7872c005eaf69e724d88d0c4701beedb"

"https://www.amazon.co.jp/s/ref=as_li_ss_tl?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&url=search-alias=aps&field-keywords=%E6%9C%AC%E5%BD%93%E3%81%AF%E6%80%96%E3%81%84C%E8%A8%80%E8%AA%9E&rh=i:aps,k:%E6%9C%AC%E5%BD%93%E3%81%AF%E6%80%96%E3%81%84C%E8%A8%80%E8%AA%9E&linkCode=ll2&tag=johshisha-22&linkId=f538bec0edfb9ccee1dbc35725f5cf24"

"https://www.amazon.co.jp/s/ref=as_li_ss_tl?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&url=search-alias=stripbooks&field-keywords=%E6%9C%AC%E5%BD%93%E3%81%AF%E6%80%96%E3%81%84C%E8%A8%80%E8%AA%9E&rh=n:465392,k:%E6%9C%AC%E5%BD%93%E3%81%AF%E6%80%96%E3%81%84C%E8%A8%80%E8%AA%9E&linkCode=ll2&tag=johshisha-22&linkId=9ce2044061980e18e3bb5d615eb52f84"

keyword = "ゼロから始める"
url = "https://www.amazon.co.jp/s/ref=as_li_ss_tl?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&url=search-alias=stripbooks&field-keywords=#{keyword}&rh=n:465392,k:#{keyword}&linkCode=ll2&tag=johshisha-22"


