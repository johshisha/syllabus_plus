class StockSubjectsController < ApplicationController
  def index
    weeks, periods = get_week_and_periods
    @weeks = weeks
    @periods = periods
    subject_ids = ids "get"
    @subjects = SummarizedSubject.where(id: subject_ids)
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
      week = params[:week] ? weeks[params[:week].to_i] : nil
      value = params[:period] ? periods[params[:period].to_i] : nil
      subject_id = params[:subject_id]
    rescue
      data = nil
      subject_id = nil
    end
    respond_to do |format|
      if week && value && subject_id
        schedules "add", [subject_id, [week, value]]
        ids "add", subject_id
        format.js { @status = {"status": "success", "id": subject_id} }
      else
        format.js { @status = {"status": "fail"} }
      end
    end
  end

  def destroy
    subject_id = params[:id]
    respond_to do |format|
      if subject_id
        schedules "delete", subject_id
        ids "delete", subject_id
        p subject_id
        format.js { @status = {"status": "success", "id": subject_id} }
      else
        format.js { @status = {"status": "fail"} }
      end
    end
  end
  
  def clear
    cookies.delete "subject_schedules"
    cookies.delete "subjects"
    redirect_to stock_subjects_url
  end
  
  def get_week_and_periods
    return [["月", "火", "水", "木", "金", "土"], Array(1..7)]
  end
  
  def schedules(method, data=nil)
    cookie_hash = cookies["subject_schedules"].present? ? JSON.parse(cookies["subject_schedules"]).stringify_keys : {}
    if method == 'add'
      subject_id, value = data[0], data[1]
      cookie_hash.store(subject_id, value)
    elsif method == 'delete'
      cookie_hash.delete(data)
    elsif method == 'get'
      return cookie_hash
    end
    cookies["subject_schedules"] = JSON.dump cookie_hash.stringify_keys
  end
  
  def ids(method, data=nil)
    subject_ids = (cookies["subjects"] || "").split("&").reject(&:blank?)
    if method == "add"
      subject_ids.push(data)
    elsif method == 'delete'
      subject_ids.delete(data)
    elsif method == 'get'
      return subject_ids
    end
    cookies["subjects"] = subject_ids
  end
end
