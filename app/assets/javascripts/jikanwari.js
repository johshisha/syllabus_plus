$(function(){
  if (window.navigator.cookieEnabled) {
  	$(".cookie-debug").append( "<p>クッキーは利用できます</p>");	// クッキーの受け入れが有効時の処理
  }
  else {
  	$(".cookie-debug").append( "<p>クッキーは利用できません</p>");	// クッキーの受け入れが無効時の処理
  }
});

function update_cookie(){
  $(".cookie-debug").text($.cookie('subjects'));
}
