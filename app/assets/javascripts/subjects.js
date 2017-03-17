/**
 *  ユーザーのデバイスを返す
 *  @return     スマホ(sp)、タブレット(tab)、その他(other)
 */
var getDevice = (function(){
    var ua = navigator.userAgent;
    if(ua.indexOf('iPhone') > 0 || ua.indexOf('iPod') > 0 || ua.indexOf('Android') > 0 && ua.indexOf('Mobile') > 0){
        return 'sp';
    }else if(ua.indexOf('iPad') > 0 || ua.indexOf('Android') > 0){
        return 'tab';
    }else{
        return 'other';
    }
})();

var is_pc = (function(){
  if (getDevice == "sp") {
    return false;
  }else{
    return true;
  }
})();

function initialize_datatalbes(){
  if (getDevice == "sp"){
    var thead = "<tr>"+
    "<th>科目名</th>" +
    "<th>A</th>" +
    "<th>F</th>" +
    "<th>平均評点</th>" +
    "<th></th>" +
    "</tr>";
    if ($(".msg-for-sp").find(".notice").length == 0){
      $(".msg-for-sp").append('<p class="notice">このサイトはPC推奨です</p>');
    }
  }else{
    var thead = "<tr class='thead-data'>"+
    "<th>科目名</th>" +
    "<th>A</th>" +
    "<th>B</th>" +
    "<th>C</th>" +
    "<th>D</th>" +
    "<th>F</th>" +
    "<th>平均評点</th>" +
    "<th></th>" +
    "</tr>";
  }
  if ($(".datatables-thead").find(".thead-data").length == 0){
    $(".datatables-thead").append(thead);
  }
}

function load_table() {  
  $.extend( $.fn.DataTable.defaults, {
      language: {
          url: "http://cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Japanese.json"
      } 
  });
  debugger;
  if (is_pc){
    var table = $('#subjects').DataTable( {
      // "sPaginationType": "full_numbers",
      "JQueryUI": true,
      "processing": true,
      "serverSide": true,
      "responsive": true,
      "iDisplayLength": 50,
      "order" : [["8", 'desc']],
      "ajax": {
        "url": "faculties/list",
        "dataType": 'json',
        "data": function ( d ) {
            var dt_params = {"faculty_ids": faculty_ids, "term_ids": term_ids}; //defined in checkboxes.js
            // Add dynamic parameters to the data object sent to the server
            if(dt_params){ $.extend(d, dt_params); }
         }
      },
      "columns": [
        {
          "data": "name",
          "render":function (data) {
            var link = data.split("===")
            return '<a target="_blank" href="'+link[1]+'">'+link[0]+'</a>';
          }
        },
        { "data": "A", "orderSequence": [ "desc", "asc"] },
        { "data": "B", "orderSequence": [ "desc", "asc"] },
        { "data": "C", "orderSequence": [ "desc", "asc"] },
        { "data": "D", "orderSequence": [ "desc", "asc"] },
        { "data": "F", "orderSequence": [ "desc", "asc"]},
        { "data": "mean_score", "orderSequence": [ "desc", "asc"], "width": "5%"},
        {
          "orderable":      false,
          "data":           "subject_id",
          "render":function (data) {
            return render_table_td(data);
          }
        },
        { "data": "weighted_score", "visible": false},
      ],
    });
  }else{
    var table = $('#subjects').DataTable( {
      // "sPaginationType": "full_numbers",
      "JQueryUI": true,
      "processing": true,
      "serverSide": true,
      "responsive": true,
      "iDisplayLength": 50,
      "order" : [["5", 'desc']],
      "ajax": {
        "url": "faculties/list",
        "dataType": 'json',
        "data": function ( d ) {
            var dt_params = {"faculty_ids": faculty_ids, "term_ids": term_ids}; //defined in checkboxes.js
            // Add dynamic parameters to the data object sent to the server
            if(dt_params){ $.extend(d, dt_params); }
         }
      },
      "columns": [
        {
          "data": "name",
          "render":function (data) {
            var link = data.split("===")
            return '<a href="'+link[1]+'">'+link[0]+'</a>';
          },
          "width": "15%"
          
        },
        { "data": "A", "orderSequence": [ "desc", "asc"] },
        { "data": "F", "orderSequence": [ "desc", "asc"]},
        { "data": "mean_score", "orderSequence": [ "desc", "asc"], "width": "8%"},
        {
          "orderable":      false,
          "data":           "subject_id",
          "render":function (data) {
            return render_table_td(data);
          }
        },
        { "data": "weighted_score", "visible": false},
      ],
    });
    
  }
}
