class StockSubjectsController < ApplicationController
  def index
    ids = (cookies["subjects"] || "") .split(',').reject(&:blank?)
    @subjects = SummarizedSubject.where(id: ids)
    @schedules = cookies["subject_schedules"] || {}
  end
  
  def show
    weeks, periods = get_week_and_periods
    @weeks = weeks
    @periods = periods
    @subject = SummarizedSubject.find(params[:id])
    @present = (cookies["subjects"] || "").split("&").reject(&:blank?).include?(@subject.id.to_s)
  end

  def new
    weeks, periods = get_week_and_periods
    @weeks = weeks
    @periods = periods
  end

  def create
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
        schedules "add", [subject_id, data]
        ids "add", subject_id
        format.js { @status = "success"}
      else
        format.js { @status = "fail"}
      end
    end
  end

  def destroy
    subject_id = params[:id]
    schedules "delete", subject_id
    ids "delete", subject_id
  end
  
  def get_week_and_periods
    return [["月", "火", "水", "木", "金", "土"], Array(1..7)]
  end
  
  def schedules(method, data)
    cookie_hash = cookies["subject_schedules"].present? ? JSON.parse(cookies["subject_schedules"]).stringify_keys : {}
    if method == 'add'
      subject_id, value = data[0], data[1]
      cookie_hash.store(subject_id, value)
    elsif method == 'delete'
      cookie_hash.delete(data)
    elsif method == 'get'
      return cookie_hash
    end
    cookies["subject_schedules"] = cookie_hash.stringify_keys
  end
  
  def ids(method, data)
    subject_ids = (cookies["subjects"] || "").split("&").reject(&:blank?)
    if method == "add"
      subject_ids.push(data)
    elsif method == 'delete'
      binding.pry
      subject_ids.delete(data)
    elsif method == 'get'
      return subject_ids
    end
    cookies["subjects"] = subject_ids
  end
end
