class StockSubjectsController < ApplicationController
  def index
    weeks, periods = get_week_and_periods
    @weeks = weeks
    @periods = periods
    @schedules = schedules "get"
    subject_ids = ids "get"
    @subjects = SummarizedSubject.where(subject_id: subject_ids)
  end
  
  def show
    weeks, periods = get_week_and_periods
    @weeks = weeks
    @periods = periods
    @subject = SummarizedSubject.find_by(subject_id: params[:id])
    @present = ids("get").include?(@subject.subject_id.to_s)
  end

  def new
    weeks, periods = get_week_and_periods
    @weeks = weeks
    @periods = periods
  end

  def create
    weeks, periods = get_week_and_periods
    week = params[:week]
    period_array = params[:periods]
    subject_id = params[:subject_id]
    respond_to do |format|
      if week && period_array && subject_id
        schedules "add", [subject_id, [week, period_array]]
        ids "add", subject_id
        uuid = cookies.signed["uuid"]
        if log = StockedLog.find_by(uuid: uuid, subject_id: subject_id)
          log.update(uuid: uuid, subject_id: subject_id, week: week, periods: period_array)
        else
          StockedLog.create(uuid: uuid, subject_id: subject_id, week: week, periods: period_array)
        end
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
    cookies.permanent["subject_schedules"] = JSON.dump cookie_hash.stringify_keys
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
    cookies.permanent["subjects"] = subject_ids
  end
end
