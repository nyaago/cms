// === 一覧ページ====
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


// === 編集ページの巻数  ===

// 公開開始日の入力divを表示
function showPublishedFrom() {
  $("div#published_from").css("display", "block");
}

// 公開/下書き切り替えの入力divを表示
function showPublished() {
  $("div#published").css("display", "block");
}

// 公開開始日の入力のcancel.値を元の値に戻して入力部分のdivを非表示にする
function cancelPublishedFrom() {
  $("#published_from_select_date").val($("#published_from_date").val());
  $("#published_from_select_hour").val($("#published_from_hour").val());
  $("#published_from_select_minute").val($("#published_from_minute").val());
  $("div#published_from").css("display", "none");
}

// 公開/下書き切り替えの入力のcancel.値を元の値に戻して入力部分のdivを非表示にする
function cancelPublished() {
  $("#article_published_select").attr('selected', $("#blog_article_published").attr('selected'));
  $("div#published").css("display", "none");
}

// 公開開始日の入力の確定.
// 1.値をサーバーでの登録対象となるフォームのhiddenフィールドに設定. 
// 2.ステータス表示部分のテキストの更新
// 3.入力部分のdivを非表示にする
function okPublishedFrom() {
  $("#published_from_date").val($("#published_from_select_date").val());
  $("#published_from_hour").val($("#published_from_select_hour").val());
  $("#published_from_minute").val($("#published_from_select_minute").val());
  var dt = new Date($("#published_from_date").val() +  " " +
  $("#published_from_hour").val()  + ":"+ $("#published_from_minute").val() + ":00" );
  $("div#published_from").css("display", "none");
  $('#published_from_status').text(dt.toJapaneseString());
}

// 公開/下書きの入力の確定.
// 1.値をサーバーでの登録対象となるフォームのhiddenフィールドに設定. 
// 2.ステータス表示部分のテキストの更新
// 3.入力部分のdivを非表示にする
function okPublished() {
  
    $("#blog_article_published").val($("#article_published_select").val());
    $("div#published").css("display", "none");
    if($("#blog_article_published").val()) {
      $('#published_status').text('公開中');
    }
    else {
      $('#published_status').text('下書き');
    }
}

// 公開予定日入力のフォーム要素の内容をクリア
function clearPublishedFrom() {
  $("#published_from_select_date").val('');
  $("#published_from_select_hour").val( '00');
  $("#published_from_select_minute").val( '00');
  
}

