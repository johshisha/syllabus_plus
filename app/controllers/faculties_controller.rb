class FacultiesController < ApplicationController
  def index
    @faculties = Faculty.paginate(page: params[:page])
  end
  
  def show
    @faculty = Faculty.find(params[:id])
    @subjects = @faculty.summarized_subjects.includes(:year_data).order("weighted_score desc").paginate(page: params[:page])
  end
end
