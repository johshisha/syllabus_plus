require "moji"

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
  
  def convert_to_en(val)
    # 全角を半角に，半角カナを全角カナにする
    return val if not val
    val = Moji.han_to_zen(val)
    val = convert_roman_to_alphabet(val)
    val = val.tr('\ー\－０-９ａ-ｚＡ-Ｚ（）　’”，．＆｜', '\-\-0-9a-zA-Z() \'\",.&')
    val = val.gsub(' ', '')
  end
  
  def convert_roman_to_alphabet(val)
    # ローマ数字をアルファベットで表記するように変更
    def add_str(num, str)
      if num >= 9
        str+= "X"
        num -= 10
      elsif num >= 4
        str += "V"
        num -= 5
      elsif num < 0
        str.insert(0, "I")
        num += 1
      elsif num > 0
        str += "I"
        num -= 1
      elsif num == 0
        return str
      end
      return add_str(num, str)
    end
    if v = val.match(/[Ⅰ-Ⅹ]/)
      num = v[0].ord - ("Ⅰ".ord-1)
      alphabet = add_str(num, "")
      val = val.gsub(v[0], alphabet)
    end
    return val
  end
end
