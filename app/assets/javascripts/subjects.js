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

var sort_index = "10"; // for datatables
function initialize_datatalbes(){
  if (getDevice == "sp"){
    var thead = "<tr>"+
    "<th>科目名</th>" +
    "<th>A</th>" +
    "<th>F</th>" +
    "<th>平均評点</th>" +
    "<th></th>" +
    "</tr>";
    sort_index = "5";
    $(".msg-for-sp").append('<p class="notice">このサイトはPC推奨です</p>');
  }else{
    var thead = "<tr>"+
    "<th></th>" +
    "<th>科目名</th>" +
    "<th>科目コード</th>" +
    "<th>A</th>" +
    "<th>B</th>" +
    "<th>C</th>" +
    "<th>D</th>" +
    "<th>F</th>" +
    "<th>平均評点</th>" +
    "<th></th>" +
    "</tr>";
  }
  $(".datatables-thead").append(thead);
}


function format ( d ) {
  // `d` is the original data object for the row
  html = '<table class="year_data" cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">';
  html += 
  '<thead>' +
    '<tr>'+
        '<th>年度</th>'+
        '<th>受講者数</th>'+
        '<th>A</th>'+
        '<th>B</th>'+
        '<th>C</th>'+
        '<th>D</th>'+
        '<th>F</th>'+
        '<th>平均評点</th>'+
    '</tr>'+
  '</thead>';
  for(var i=0,data;data=d.year_data[i];i++){
    html +=
    '<tr>'+
        '<td><a href="'+data.url+'">'+data.year+'</a></td>'+
        '<td>'+data.number_of_students+'</td>'+
        '<td>'+data.A+'</td>'+
        '<td>'+data.B+'</td>'+
        '<td>'+data.C+'</td>'+
        '<td>'+data.D+'</td>'+
        '<td>'+data.F+'</td>'+
        '<td>'+data.mean_score+'</td>'+
    '</tr>';
  }
  html += '</table>';
  return html;  
}

function load_table() {  
  $.extend( $.fn.DataTable.defaults, {
      language: {
          url: "http://cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Japanese.json"
      } 
  });
  if (is_pc){
    var table = $('#subjects').DataTable( {
      // "sPaginationType": "full_numbers",
      "JQueryUI": true,
      "processing": true,
      "serverSide": true,
      "responsive": true,
      "iDisplayLength": 50,
      "order" : [["10", 'desc']],
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
            "className":      'my-button',
            "orderable":      false,
            "data":           null,
            "defaultContent": '',
            "width": "5%",
        },
        {
          "data": "name",
          "render":function (data) {
            var link = data.split("===")
            return '<a href="'+link[1]+'">'+link[0]+'</a>';
          }
        },
        { "data": "code", "orderSequence": [ "desc", "asc"] },
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
  
  // Add event listener for opening and closing details
  $('#subjects tbody').on('click', 'td.my-button', function () {
      var tr = $(this).closest('tr');
      var row = table.row( tr );

      if ( row.child.isShown() ) {
          // This row is already open - close it
          row.child.hide();
          tr.removeClass('shown');
      }
      else {
          // Open this row
          row.child( format(row.data()), "detail-table" ).show();
          tr.addClass('shown');
      }
  } );
}
