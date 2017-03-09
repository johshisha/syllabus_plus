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
          var dt_params = {"faculty_ids": faculty_ids};
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
      },
      {
        "data": "name",
        "render":function (data) {
          var link = data.split("===")
          return '<a href="'+link[1]+'">'+link[0]+'</a>';
        }
      },
      { "data": "code" },
      { "data": "A", "orderSequence": [ "desc", "asc"]},
      { "data": "B", "orderSequence": [ "desc", "asc"]},
      { "data": "C", "orderSequence": [ "desc", "asc"]},
      { "data": "D", "orderSequence": [ "desc", "asc"]},
      { "data": "F", "orderSequence": [ "desc", "asc"]},
      { "data": "mean_score", "orderSequence": [ "desc", "asc"]},
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
