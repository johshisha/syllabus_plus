function format ( d ) {
  // `d` is the original data object for the row
  debugger;
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
        '<td>'+data.year+'</td>'+
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

$(document).ready(function() {
  var table = $('#subjects').DataTable( {
    "sPaginationType": "full_numbers",
    "JQueryUI": true,
    "processing": true,
    "serverSide": true,
    "order" : [["8", 'desc']],
    "ajax": "show",
    "columns": [
            {
                "className":      'details-control',
                "orderable":      false,
                "data":           null,
                "defaultContent": ''
            },
            { "data": "name" },
            { "data": "code" },
            { "data": "A"},
            { "data": "B"},
            { "data": "C"},
            { "data": "D"},
            { "data": "F"},
            { "data": "mean_score"},
        ],
    });
  // Add event listener for opening and closing details
  $('#subjects tbody').on('click', 'td.details-control', function () {
      var tr = $(this).closest('tr');
      var row = table.row( tr );

      if ( row.child.isShown() ) {
          // This row is already open - close it
          row.child.hide();
          tr.removeClass('shown');
      }
      else {
          // Open this row
          row.child( format(row.data()) ).show();
          tr.addClass('shown');
      }
    } );
  } );
