class FacultiesController < ApplicationController
  def index
    @faculties = Faculty.paginate(page: params[:page])
  end
  
  def show
    @faculty = Faculty.find(params[:id])
    @subjects = @faculty.subjects.includes(:year_data).paginate(page: params[:page])
  end
end
