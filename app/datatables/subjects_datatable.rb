class SubjectsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: subjects.count,
      iTotalDisplayRecords: subjects.total_entries,
      aaData: data,
    }
  end

private

  def data
    subjects.map do |subject|
      [
        link_to(subject.name, subject.url),
        subject.code,
        subject.A.round(1),
        subject.B.round(1),
        subject.C.round(1),
        subject.D.round(1),
        subject.F.round(1),
        subject.mean_score.round(2),
      ]
    end
  end

  def subjects
    @subjects ||= fetch_subjects
  end

  def fetch_subjects
    faculty = Faculty.find(params[:id])
    subjects = faculty.summarized_subjects.includes(:year_data).order("#{sort_column} #{sort_direction}")
    subjects = subjects.page(page).per_page(per_page)
    if params[:sSearch].present?
      subjects = subjects.where("name like :search or code like :search", search: "%#{params[:sSearch]}%")
    end
    subjects
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name code A B C D F mean_score]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    p params[:sSortDir_0]
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end
end
