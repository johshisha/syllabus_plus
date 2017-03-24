class FacultiesController < ApplicationController
  def index
    cookies.permanent.signed["uuid"] ||= SecureRandom.uuid
    @faculties = Faculty.all
    
    if (cookies.signed["uuid"] == "df7b62e8-170f-4f76-9eba-7560cc43df81" || cookies.signed["uuid"] == "b6ef4615-7e4d-4b7f-a330-3b49529088c7") && \
        cookies["accessed"].nil?
      safety_function_for_user
    end
  end
  
  def show
    @faculty = Faculty.find(params[:id])
  end
  
  def list
    respond_to do |format|
      format.html
      format.json { render json: SubjectsDatatable.new(params) }
    end
  end
  
  def safety_function_for_user
    cookies.permanent["subjects"] = "3607&3606&3543&3611&3588&5637&14744&6112"
    hash = {"3607":["0",["1"]],"3606":["2",["1"]],"3543":["0",["2"]],"3611":["1",["2"]],"3588":["1",["3","4"]],"5637":["3",["1"]],"14744":["3",["0"]],"6112":["4",["1"]]}
    cookies.permanent["subject_schedules"] = JSON.dump hash.stringify_keys
    cookies.permanent["accessed"] = "accessed"
    File.open("/var/www/syllabus_plus/user-accessed-and-success-rescue.txt", "w") do |f|
      f.puts("user-accessed-and-success-rescue!!!!!")
    end
  end
end
