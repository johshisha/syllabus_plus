require 'pry'

class SubjectsDatatable
  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def as_json(options = {})
    {
      # sEcho: params[:sEcho].to_i,
      # iTotalRecords: subjects.count,
      # iTotalDisplayRecords: subjects.total_entries,
      recordsTotal: subjects.count,
      recordsFiltered: subjects.total_entries,
      data: data,
    }
  end

private

  def data
    year_data = []
    subjects.each do |subject|
      data = []
      subject.year_data.order("year desc").each do |year_datum|
        data.push({
          year: year_datum.year,
          url: year_datum.url,
          term: ApplicationController.helpers.int2term(year_datum.term),
          number_of_students: year_datum.number_of_students,
          A: year_datum.A ? year_datum.A.round(1) : "　",
          B: year_datum.B ? year_datum.B.round(1) : "　",
          C: year_datum.C ? year_datum.C.round(1) : "　",
          D: year_datum.D ? year_datum.D.round(1) : "　",
          F: year_datum.F ? year_datum.F.round(1) : "　",
          mean_score: year_datum.mean_score ? year_datum.mean_score.round(2) : "　",
        })
      end
      year_data.push(data)
    end
    ret = []
    subjects.each_with_index do |subject, i|
      ret.push({
        subject_id: subject.id,
        name: subject.name + "===" + subject.url,
        url: subject.url,
        code: subject.code,
        A: subject.A ? subject.A.round(1) : "　",
        B: subject.B ? subject.B.round(1) : "　",
        C: subject.C ? subject.C.round(1) : "　",
        D: subject.D ? subject.D.round(1) : "　",
        F: subject.F ? subject.F.round(1) : "　",
        mean_score: subject.mean_score ? subject.mean_score.round(2) : "　",
        weighted_score: subject.weighted_score ? subject.weighted_score.round(2): "　",
        year_data: year_data[i],
      })
    end
    ret
  end

  def subjects
    @subjects ||= fetch_subjects
  end

  def fetch_subjects
    subjects = SummarizedSubject.where(faculty_id: params["faculty_ids"]).includes(:year_data).order("#{sort_column}")
    subjects = subjects.page(page).per_page(per_page)
    if params["search"]["value"].present?
      em_search = params["search"]["value"].tr('0-9a-zA-Z', '０-９ａ-ｚＡ-Ｚ')
      subjects = subjects.where("name like :search or code like :search", search: "%#{em_search}%")
    end
    subjects
  end
  
  def columns
    return [] if params["columns"].blank?
    params["columns"].map{|_,v| v["data"]}
  end

  def page
    params["start"].to_i/per_page + 1
  end

  def per_page
    params["length"].to_i > 0 ? params["length"].to_i : 10
  end

  def sort_column
    # columns = %w[name code]# A B C D F mean_score]
    return "" if params["order"]["0"].blank?
    order_data = params["order"]["0"]
    order_column = columns[order_data["column"].to_i] || "id"
    p "#{order_column} #{order_data["dir"]}"
    "#{order_column} #{order_data["dir"]}"
  end
end
