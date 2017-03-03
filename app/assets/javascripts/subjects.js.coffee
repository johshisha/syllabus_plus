jQuery ->
  $('#subjects').dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    aaSorting : [[7, 'desc']]
    sAjaxSource: $('#subjects').data('source')
