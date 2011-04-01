// 公開予定日入力のフォーム要素の内容をクリア
function clearCancellationReservedAt() {
  $("#cancellation_reserved_at_select_date").val('');
  $("#cancellation_reserved_at_select_hour").val( '00');
  $("#cancellation_reserved_at_select_minute").val( '00');
  
}


// 公開開始日の入力のcancel.
function cancelCancellationReservedAt() {
  $("#cancellation_reserved_at_select_date").val($("#cancellation_reserved_at_date").val());
  $("#cancellation_reserved_at_select_hour").val($("#cancellation_reserved_at_hour").val());
  $("#cancellation_reserved_at_select_minute").val($("#cancellation_reserved_at_minute").val());
}

function fixCancellationReservedAt() {
  $("#cancellation_reserved_at_date").val($("#cancellation_reserved_at_select_date").val());
  $("#cancellation_reserved_at_hour").val($("#cancellation_reserved_at_select_hour").val());
  $("#cancellation_reserved_at_minute").val($("#cancellation_reserved_at_select_minute").val());
  
}