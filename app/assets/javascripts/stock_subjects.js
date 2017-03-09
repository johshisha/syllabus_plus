var modal_status = "canceled";
var modal_input = "";
var cookie_array =[];
function get_subjects_cookie_array(){
  subject_ids = $.cookie('subjects').split(',');
  cookie_array = subject_ids;
}

function stock_subject(element){
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
  get_subjects_cookie_array();
  if (cookie_array.indexOf(String(data)) >= 0) {
    text = 'unstock';
    type = '';
  }else{
    text = 'stock';
  }
  var ret = '<input type="text" class="stock-input" size="5" maxlength="2">'+
          '<button type="button" class="stock-button btn btn-primary" data-toggle="modal" data-target="#modal-example">'+text+'</button>';
  return ret
}


// // modal popup
// function remodal_open(element) {
//   var id = element.id;
//   var modal = $('[data-remodal-id=modal]').remodal(id)
//   modal.open();
// }
// 
// $(document).on('confirmation', '.remodal', function () {
//   console.log('Confirmation button is clicked');
//   modal_status = "confirmed";
//   var modal = $(this);
//   modal_input = modal.children('input').val();
//   
// });

// $(function($) {
//     'use strict';
//     // JavaScript で表示
//     $('#staticModalButton').on('click', function() {
//       $('#staticModal').modal();
//     });
//     // ダイアログ表示前にJavaScriptで操作する
//     $('#staticModal').on('show', function(event) {
//       var button = $(event.relatedTarget);
//       var recipient = button.data('whatever');
//       var modal = $(this);
//       modal.find('.modal-body .recipient').text(recipient);
//       //modal.find('.modal-body input').val(recipient);
//     });
//     // ダイアログ表示直後にフォーカスを設定する
//     $('#staticModal').on('shown', function(event) {
//       $(this).find('.modal-footer .btn-default').focus();
//     });
//     $('#staticModal').on('click', '.modal-footer .btn-primary', function() {
//       $('#staticModal').modal('hide');
//       alert('変更を保存をクリックしました。');
//     });
//   });
