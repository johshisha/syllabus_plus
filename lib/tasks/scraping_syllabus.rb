
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

# robotex = Robotex.new
# p "robots: #{robotex.allowed?(url)}"hash = Hash.new(0)

hash = Hash.new(0)

subject = SummarizedSubject.find_by(subject_id: 1284)

url = subject.url
agent = Mechanize.new
page = agent.get(url)
data = page.css('body > div > table:nth-child(2) > tbody > tr:nth-child(4) > td')
children=data.children
table_hash = {}
text_hash = {}
tag = 'init'
children.each do |t|
  text = t.text.strip
  if t.node_name == 'table'
    table_hash[tag] = t
  elsif text.present?
    if ret = text.match(/^＜(.+)＞$/)
      p "tag #{tag = ret[1].split('/')[0]}"
    else
      text_hash[tag] = text
    end
  end
end
table_hash["成績評価基準"].css('tbody > tr').each do |tr|
  record_tag = tr.css('td')[0].text.strip
  p record_tag
  hash[record_tag] += 1
end

p subject.subject_id

if record = table_hash["成績評価基準"]
  record.css('tbody > tr').each do |tr|
    record_tag = tr.css('td')[0].text.gsub(/(\xc2\xa0)+/, "").strip
    record_tag = "平常点" if record_tag.include?("平常点") # 平常点系は平常点でまとめる
    record_val = tr.css('td')[1].text.gsub(/(\xc2\xa0)+/, "").strip.gsub("%","")
    p "#{subject.subject_id}, 成績, #{record_tag}, #{record_val}"
  end
end

["テキスト", "参考文献"].each do |cat|
  if table_hash[cat].present?
    table_hash[cat].css('tbody > tr').each do |c|
      keywords = (c.text.scan(/『(.+?)』/) || [])
      keywords.each do |keyword|
        p "#{subject.subject_id}, #{cat}, , #{keyword[0]}"
      end
    end
  end
end

table_hash["参考文献"].css('tbody > tr')[0].text

subjects = SummarizedSubject.find(SummarizedSubject.pluck(:id).shuffle[0..100])

subjects.each do |subject|
  url = subject.url
  agent = Mechanize.new
  page = agent.get(url)
  data = page.css('body > div > table:nth-child(2) > tbody > tr:nth-child(4) > td')
  children=data.children
  table_hash = {}
  text_hash = {}
  tag = 'init'
  children.each do |t|
    text = t.text.strip
    if t.node_name == 'table'
      table_hash[tag] = t
    elsif text.present?
      if ret = text.match(/^＜(.+)＞$/)
        p "tag #{tag = ret[1].split('/')[0]}"
      else
        text_hash[tag] = text
      end
    end
  end
  table_hash["成績評価基準"].css('tbody > tr').each do |tr|
    record_tag = tr.css('td')[0].text.strip
    p record_tag
    hash[record_tag] += 1
  end
  sleep(1)
end

new_hash = Hash.new(0)
hash.sort_by {|k, v| -v }.each do |h|
  if h[0].include?("平常点")
    new_hash["平常点"] += h[1].to_i
  else
    new_hash[h[0]] += h[1].to_i
  end
end

new_hash.sort_by {|k, v| -v }.each do |h|
  p h
end

table_hash

t=table_hash["参考文献"].text

keyword = t.match(/『(.+)』/)[1]

#keyword = "ゼロから始める"
url = "https://www.amazon.co.jp/s/ref=as_li_ss_tl?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&url=search-alias=stripbooks&field-keywords=#{keyword}&rh=n:465392,k:#{keyword}&linkCode=ll2&tag=johshisha-22"


