class FacultiesController < ApplicationController
  def index
    @faculties = Faculty.paginate(page: params[:page])
  end
  
  def show
    @faculty = Faculty.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: SubjectsDatatable.new(view_context) }
    end
  end
end
