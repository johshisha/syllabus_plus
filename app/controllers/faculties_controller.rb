class FacultiesController < ApplicationController
  def index
    cookies.permanent.signed["uuid"] ||= SecureRandom.uuid
    @faculties = Faculty.all
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
end
