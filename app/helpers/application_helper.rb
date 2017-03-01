module ApplicationHelper
  term_array = ['春', '秋']
  def term2int(term)
    term_array.index(term)
  end
  
  def int2term(num)
    term_array[num]
  end
end
