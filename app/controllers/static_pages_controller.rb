require 'pry'
class StaticPagesController < ApplicationController
  def usage
  end
  
  def stocked
    ids = cookies["subjects"].split(',').reject(&:blank?)
    @subjects = SummarizedSubject.where(id: ids)
  end
end
