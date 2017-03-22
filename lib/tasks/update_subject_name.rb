
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
require "#{Rails.root}/app/models/teacher"

require "moji"

def do_convert_data(subjects)
  subjects.each do |subject|
    name = subject.name
    new = ApplicationController.helpers.convert_to_en(name)
    subject.update_attribute(:name, new)
  end
end
''

# subjects = Faculty.find(13).subjects.limit(30)
subjects = Subject.all
do_convert_data(subjects)
''

subjects = SummarizedSubject.all
do_convert_data(subjects)
''

teachers = Teacher.all
do_convert_data(teachers)
''

teachers = Teacher.where("name like '%  %'")
teachers.length

teachers[0]

teachers.each do |teacher|
  name = teacher.name.gsub(/ +/, ' ')
  teacher.update_attribute(:name, name)
end
''


