var faculty_ids = []; // === this variable is used in subjects.js ===
var term_ids = ["0", "1"];

function convert_cookie_to(type, data){
  if (type == 'array') {
    return (data||"").split('&').filter(Boolean);
  }else if (type == 'string') {
    return data.join('&');
  }
}

function cookie_to(type, data){
  var tmp = convert_cookie_to("array", $.cookie('faculties'));
  var index = tmp.indexOf(data);
  if (type=="add"){
    if (index == -1 ){
      tmp.push(data);
    }
  }else if (type=="remove") {
    if (index >= 0 ){
      tmp.splice(index, 1);
    }
  }
  $.cookie("faculties", convert_cookie_to("string",tmp));
}

// initialize
function initialize(){
  var checked_flag = 0;
  faculty_ids = convert_cookie_to("array", $.cookie('faculties'));
  // other
  $("[id=faculty_ckb]").each(function(index, element){
    if (faculty_ids.indexOf($(element).val()) >= 0){
      $(element).prop("checked",true);
      checked_flag = 1;
    }
  });
  // all
  var element = $("#all_faculty_ckb");
  if (faculty_ids.indexOf($(element).val()) >= 0){
    $(element).prop("checked",true);
    checked_flag = 1;
  }
  clicked_all(element);
  if (checked_flag == 1){
    control_checkbox_visible();
  }
}

function confirm_check_status(element) {
  faculty_ids = convert_cookie_to("array", $.cookie('faculties'));
  index = faculty_ids.indexOf($(element).val());
  if ($(element).is(':checked')) {
    if (index == -1 ){
      faculty_ids.push($(element).val());
    }
	} else {
    if (index >= 0){
      faculty_ids.splice(index, 1);
    }
	}
  $.cookie("faculties", convert_cookie_to("string", faculty_ids));
}

function clicked_all(element) {
  faculty_ids = [];
  if ($(element).is(':checked')) {
    $(".faculties #faculty_ckb").each(function() {
      faculty_ids.push($(this).val());
      $(this).attr('disabled', true);
    });
    cookie_to("add", "all");
  }else{
    $(".faculties #faculty_ckb").each(function() {
      $(this).attr('disabled', false);
      confirm_check_status(this);
    });
    cookie_to("remove", "all");
  }
}

function clicked(element) {
  if ($(element).val() == 'all') {
    clicked_all(element);
  }else {
    confirm_check_status(element);
  }
  $('#subjects').DataTable().ajax.reload(null, false);
}

function control_checkbox_visible(){
  var obj = $(".checkbox-control")
  var text = $(".checkbox-control-text")
  if(obj.attr("status")=='close') {
      obj.attr("style", "display: block")
      obj.attr('status', 'open'); 
      text.text("学部一覧を閉じる");
  }else{
      obj.attr("style", "display: none");
      obj.attr('status', 'close'); 
      text.text("学部一覧を開く");
  }
}


// for checkbox in term
function term_clicked(element) {
  index = term_ids.indexOf($(element).val());
  if ($(element).is(':checked')) {
    if (index == -1 ){
      term_ids.push($(element).val());
    }
  } else {
    if (index >= 0){
      term_ids.splice(index, 1);
    }
	}
  $('#subjects').DataTable().ajax.reload(null, false);
}
