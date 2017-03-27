#coding: utf-8
require 'pry'

require "#{Rails.root}/app/models/syllabus_datum"
require "#{Rails.root}/app/models/summarized_subject"

class BatchUpdateSyllabusData
  def self.update_table(subject)
    url = subject.url
    agent = Mechanize.new
    page = agent.get(url)
    data = page.css('body > div > table:nth-child(2) > tbody > tr:nth-child(4) > td')
    children=data.children
    # initialize hash
    table_hash = {}
    text_hash = {}
    tag = 'init'
    children.each do |t|
      text = t.text.strip
      if t.node_name == 'table'
        table_hash[tag] = t
      elsif text.present?
        if ret = text.match(/^＜(.+)＞$/)
          tag = ret[1].split('/')[0]
        else
          text_hash[tag] = text
        end
      end
    end
    
    if record = table_hash["成績評価基準"]
      record.css('tbody > tr').each do |tr|
        record_tag = tr.css('td')[0].text.gsub(/(\xc2\xa0)+/, "").strip
        record_tag = "平常点" if record_tag.include?("平常点") # 平常点系は平常点でまとめる
        record_val = tr.css('td')[1].text.gsub(/(\xc2\xa0)+/, "").strip.gsub("%","")
        if record_tag.length >= 255 || record_val.length >= 255
          p "#{subject.subject_id}, 成績, #{record_tag}, #{record_val}"
        end
        record_tag = record_tag.slice(0..255)
        record_val = record_val.slice(0..255)
        SyllabusDatum.create(subject_id: subject.subject_id, tag: "成績", category: record_tag, value: record_val)
        # p "#{subject.subject_id}, 成績, #{record_tag}, #{record_val}"
      end
    end
    
    ["テキスト", "参考文献"].each do |cat|
      if table_hash[cat].present?
        table_hash[cat].css('tbody > tr').each do |c|
          keywords = (c.text.scan(/『(.+?)』/) || [])
          keywords.each do |keyword|
            if keyword.length >= 255
              p "#{subject.subject_id}, #{cat}, , #{keyword[0]}"
            end
            keyword = keyword.slice(0..255)
            SyllabusDatum.create(subject_id: subject.subject_id, tag: cat, category: nil, value: keyword[0])
            # p "#{subject.subject_id}, #{cat}, , #{keyword[0]}"
          end
        end
      end
    end
    sleep(1)
  end
  
  def self.execute
    p "#{DateTime.now}, Start BatchUpdateSyllabusData"
    # faculties = Faculty.all
    faculties = Faculty.where('id >= 13')
    faculties.each do |faculty|
      p "faculty #{faculty.name}"
      subjects = faculty.summarized_subjects
      subjects.each do |subject|
        self.update_table subject
      end
      sleep(10)
      p "end"
    end
    p "#{DateTime.now}, Finish BatchUpdateSyllabusData"
  end
end

if __FILE__ == $0
  BatchUpdateSyllabusData.execute
end
