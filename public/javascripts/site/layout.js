
// radio button 変更時
function registOnChangeRadio(elemId) {
  $('.' + elemId + '_radio_button').each( function() {
    $(this).change(function () {
      $('.' + elemId + '_radio_button').each( function() {
        $(this).parent().parent().removeClass('selected');
      } );
      $(this).parent().parent().addClass('selected');
    });
  } ) ;
  // div 選択時、radio buttonの値変更
  $('div.' + elemId).each( function() {
    $(this).click(function () {
      var  id =  $(this).attr('id');
      var re = new RegExp(elemId + '_');
      id = id.replace(re,'');
      $('.' + elemId + '_radio_button').each( function() {
        $(this).parent().parent().removeClass('selected');
      } );
      $('.' + elemId + '_radio_button').val([id]);
      $(this).addClass('selected');
    });
  } ) ;
  
}

// radioボタンの選択
// @param elemId - タグのid
// @param value - 選択値
function selectRadio(elemId, value) {

  $('.' + elemId + '_radio_button').val([value]);
  $('div#' + elemId + '_' + value).addClass('selected');

}
