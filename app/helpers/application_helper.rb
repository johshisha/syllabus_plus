module ApplicationHelper
  def term2int(term)
    term_array = ['春', '秋']
    term_array.index(term)
  end
  
  def int2term(num)
    term_array = ['春', '秋']
    term_array[num]
  end
end
