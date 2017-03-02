// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .
function show(inputData){
    var objID=document.getElementById( "table_" + inputData );
    var buttonID=document.getElementById( "text_" + inputData );
    if(objID.getAttribute('status')=='close') {
        objID.style.display='block';
        objID.setAttribute('status', 'open'); 
        buttonID.text = "閉じる";
    }else{
        objID.style.display='none';
        objID.setAttribute('status', 'close'); 
        buttonID.text = "年度のごとの分布を見る";
    }
}
