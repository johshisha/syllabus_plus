require 'pry'
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
    content = params[:content]
    if content.present?
      flash[:success] = "問い合わせありがとうございました．今後ともよろしくお願いします．"
    else
      flash[:danger] = "内容が記入されていません．"
    end
    render "contact"
    # binding.pry
  end
end
