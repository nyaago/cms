// 月でのフィルタリング.
// #filtered_monthフィールドに月を設定してsubmit
function filterByMonth() {
  $('#filtered_month').first().val($('#filtering_month').first().val());
  $('#filteting_by_month').first().submit();
}

// 一括操作の実行
function processBatch(){
  var value = $('#blogs_processing_method option:selected').val();
  if(!value) {
    return true;
  }
  if($('.check_for_batch:checked').size() == 0) {
    alert('操作対象が選択されていません');
    return true;
  }

  $('#process_with_batch').first().submit();
}

$(document).ready( function() {
  $('#check_all').change( function() {
    checkAll($(this).attr('checked'));
    
  } );
  } );  

// アップロードの表示/非表示
function showOrHideUpload(f) {
  if(f) {
    $("#upload").css("display","block");
    $("#link_to_display_upload").text('アップロードを隠す');
    $('#display_upload').attr('value', 1);
  }
  else {
    $("#upload").css("display","none");
    $("#link_to_display_upload").text('画像をアップロード');
    $('#display_upload').attr('value', 0);
  }
}


// アップロードフォームの表示On/Off
function reverseDisplayingUpload() {
  var f  = true;
  if($("#upload").css("display") == 'none') {
    f = true;
  }
  else {
    f = false;
  }
  showOrHideUpload(f);
}

// 一覧の全てをチェック
function checkAll(check) {
  $('.check_for_batch').attr( { checked: check ? "checked" : ""} );
}
