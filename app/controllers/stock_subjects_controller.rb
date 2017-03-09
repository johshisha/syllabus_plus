class StockSubjectsController < ApplicationController
  def index
    ids = (cookies["subjects"] || "") .split(',').reject(&:blank?)
    @subjects = SummarizedSubject.where(id: ids)
    @schedules = cookies["subject_schedules"] || {}
  end

  def new
    weeks, periods = get_week_and_periods
    @weeks = weeks
    @periods = periods
  end

  def create
    binding.pry
    weeks, periods = get_week_and_periods
    
    begin
      data = [weeks[params[:week].to_i], periods[params[:period].to_i]]
      subject_id = params[:subject_id]
    rescue
      data = nil
      subject_id = nil
    end
    respond_to do |format|
      if data and subject_id
        cookie_hash = cookies["subject_schedules"] || {}
        cookie_hash.store(subject_id, data)
        cookies["subject_schedules"] = cookie_hash
        format.js { @status = "success"}
      else
        format.js { @status = "fail"}
      end
    end
  end

  def destroy
  end
  
  def get_week_and_periods
    return [["月", "火", "水", "木", "金", "土"], Array(1..7)]
  end
end
