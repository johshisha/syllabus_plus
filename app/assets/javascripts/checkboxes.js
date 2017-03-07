var faculty_ids = []

function clicked(element) {
  if ($(element).is(':checked')) {
		faculty_ids.push($(element).val());
    $('#subjects').DataTable().ajax.reload(null, false);
	} else {
    for(i=faculty_ids.length; i>=0; i--){
      if(faculty_ids[i] == $(element).val()){
          faculty_ids.splice(i, 1);
      }
    }
    $('#subjects').DataTable().ajax.reload(null, false);
	}
}

function control_checkbox_visible(inputData){
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
