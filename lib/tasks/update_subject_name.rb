
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

def convert_roman_to_alphabet(val)
  def add_str(num, str)
    if num >= 9
      str+= "X"
      num -= 10
    elsif num >= 4
      str += "V"
      num -= 5
    elsif num < 0
      str.insert(0, "I")
      num += 1
    elsif num > 0
      str += "I"
      num -= 1
    elsif num == 0
      return str
    end
    return add_str(num, str)
  end
  if v = val.match(/[Ⅰ-Ⅹ]/)
    num = v[0].ord - ("Ⅰ".ord-1)
    alphabet = add_str(num, "")
    val = val.gsub(v[0], alphabet)
  end
  return val
end

def convert_to_en(val)
  val = Moji.han_to_zen(val)
  val = convert_roman_to_alphabet(val)
  val = val.tr('\ー\－０-９ａ-ｚＡ-Ｚ（）　’”，．＆｜', '\-\-0-9a-zA-Z() \'\",.&')
  val = val.gsub(' ', '')
end

def do_convert_data(subjects)
  subjects.each do |subject|
    name = subject.name
    new = convert_to_en(name)
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


