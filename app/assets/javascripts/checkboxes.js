var faculty_ids = [];

function confirm_check_status(element) {
  if ($(element).is(':checked')) {
    faculty_ids.push($(element).val());
	} else {
    for(i=faculty_ids.length; i>=0; i--){
      if(faculty_ids[i] == $(element).val()){
        faculty_ids.splice(i, 1);
      }
    }
	}
}

function clicked_all(element) {
  faculty_ids = [];
  if ($(element).is(':checked')) {
    $(".faculties #faculty_ckb").each(function() {
      faculty_ids.push($(this).val());
      $(this).attr('disabled', true);
    });
  }else{
    $(".faculties #faculty_ckb").each(function() {
      $(this).attr('disabled', false);
      confirm_check_status(this);
    });
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
