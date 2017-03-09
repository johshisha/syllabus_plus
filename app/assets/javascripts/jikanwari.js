var cookie_array =[];
function get_cookie_array(){
  subject_ids = $.cookie('subjects').split(',');
  cookie_array = subject_ids;
}

function click_stock_button(element){
  subject_id = element.id
  
  var index = cookie_array.indexOf(subject_id);
  if (index == -1){ // don't exist subject_id
    cookie_array.push(subject_id);
    $(element).children('small').text('unstock');
  }else{
    cookie_array.splice(index, 1) ;
    $(element).children('small').text('stock');
  }
  $.cookie('subjects', cookie_array);
}

function render_table_td(data){
  get_cookie_array();
  if (cookie_array.indexOf(String(data)) >= 0) {
    text = 'unstock';
    type = '';
  }else{
    text = 'stock';
  }
  return '<input type="text" class="stock-input" size="5" maxlength="2"><button type="button" class="stock-button btn btn-default" id="'+data+'" onclick="click_stock_button(this);"><small>'+text+'</small></button>';
}
