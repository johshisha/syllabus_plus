class SummarizedSubjectsController < ApplicationController
  def show
    @summarized_subject = SummarizedSubject.find(params[:id])
  end
end
