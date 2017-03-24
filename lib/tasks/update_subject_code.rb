
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
''

hash = {}
faculties.each do |faculty|
  hash[faculty.name] =  '1'+faculty.code.slice(-2..-1)
end
''

hash={"神学部"=>"101", "文学部"=>"102", "法学部"=>"103", "経済学部"=>"104", "商学部"=>"105", "政策学部"=>"107", "文化情報学部"=>"108", "社会学部"=>"109", "生命医科学部"=>"114", "スポーツ健康科学部"=>"115", "理工学部"=>"116", "心理学部"=>"117", "グローバル・コミュニケーション学部"=>"119", "国際教育インスティテュート"=>"120", "グローバル地域文化学部"=>"122", "語学科目"=>"165", "保健体育科目"=>"161", "留学生科目"=>"190", "全学共通教養教育科目"=>"160"}


