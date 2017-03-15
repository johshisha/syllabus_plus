module ApplicationHelper
  def term2int(term)
    term_array = ['春', '秋']
    term_array.index(term)
  end
  
  def int2term(num)
    term_array = ['春', '秋']
    term_array[num]
  end
  
  def place2int(place)
    place_array = ['今出川', '京田辺']
    place_array.index(place)
  end
  
  def int2place(num)
    place_array = ['今出川', '京田辺']
    place_array[num]
  end
end
