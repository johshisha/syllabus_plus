require 'slack/incoming/webhooks'

class StaticPagesController < ApplicationController
  def usage
  end
  
  def agreement
  end
  
  def notice
  end
  
  def q_and_a
  end
  
  def contact
    @uuid = cookies.signed["uuid"]
  end
  
  def post_contact
    uuid = params[:uuid]
    email = params[:email]
    content = params[:content]
    if content.present?
      slack = Slack::Incoming::Webhooks.new ENV['SLACK_URL']
      attachments = [{
        title: "問い合わせ UUID:#{uuid}, mail:#{email}",
        text: "#{content}",
        color: "#fbec00"
      }]
      slack.post "@johshisha From #{email}", attachments: attachments
      redirect_to contact_url, :notice => "問い合わせありがとうございました．今後ともよろしくお願いします．"
    else
      redirect_to contact_url, :alert => "内容が記入されていません．"
    end
  end
  
  def popularity
    limit_num = 20
    @faculties = Faculty.all
    if faculty_id = params["faculty_id"]
      ordered = StockedLog.joins(:summarized_subject).where("faculty_id = #{faculty_id}").group(:subject_id).order('count_subject_id desc').count('subject_id')
    else
      ordered = StockedLog.group(:subject_id).order('count_subject_id desc').count('subject_id')
    end
    keys = ordered.keys
    @values = ordered.values
    @subjects = SummarizedSubject.where(subject_id: keys).sort_by {|p| keys.index(p.subject_id) }
  end
end
