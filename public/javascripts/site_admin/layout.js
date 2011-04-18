
// radio button 変更時
function registOnChangeRadio(elemClass) {
  $('.' + elemClass + '_radio_button').each( function() {
    $(this).change(function () {
      $('.' + elemClass + '_radio_button').each( function() {
        $('div.' + elemClass + ':has(#' + $(this).attr('id') + ')').removeClass('selected');
      } );
      $('div.' + elemClass + ':has(#' + $(this).attr('id') + ')').addClass('selected');
    });
  } ) ;
  // div 選択時、radio buttonの値変更
  $('div.' + elemClass).each( function() {
    $(this).click(function () {
      var  id =  $(this).attr('id');
      var re = new RegExp(elemClass + '_');
      id = id.replace(re,'');
      $('.' + elemClass + '_radio_button').each( function() {
        $('div.' + elemClass + ':has(#' + $(this).attr('id') + ')').removeClass('selected');
      } );
      $('.' + elemClass + '_radio_button').val([id]);
      $(this).addClass('selected');
    });
  } ) ;
  
}

// radioボタンの選択
// @param elemClass - タグの Class
// @param value - 選択値
function selectRadio(elemClass, value) {

  $('.' + elemClass + '_radio_button').val([value]);
  $('div#' + elemClass + '_' + value).addClass('selected');

}
