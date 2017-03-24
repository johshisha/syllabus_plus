
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

faculties = Faculty.all

hash={"神学部"=>"101", "文学部"=>"102", "法学部"=>"103", "経済学部"=>"104", "商学部"=>"105", "政策学部"=>"107", "文化情報学部"=>"108", "社会学部"=>"109", "生命医科学部"=>"114", "スポーツ健康科学部"=>"115", "理工学部"=>"116", "心理学部"=>"117", "グローバル・コミュニケーション学部"=>"119", "国際教育インスティテュート"=>"120", "グローバル地域文化学部"=>"122", "語学科目"=>"165", "保健体育科目"=>"161", "留学生科目"=>"190", "全学共通教養教育科目"=>"160"}

# 物質の科学1-1
'16016502001'
'160G9003001'

'16502'
'G9003'

# 生命の科学1-4
'16016506004'
'160G9007004'

# 科学史・科学論1-5
'16006633005'
'160G9009005'

faculties.each do |faculty|
  faculty.subjects.each do |subject|
    if subject.code.length < 11
      code = hash[faculty.name] + subject.code
      subject.update_attribute(:code, code)
    end
  end
end


