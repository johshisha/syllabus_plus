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
end
