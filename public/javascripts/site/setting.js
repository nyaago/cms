// 最後のradioボタンの値と等しいradio buttonがあれば、そのradio buttonをcheckして　、最後のものをuncheck
function recheckRadioWithLastRadio(radioButtons) {
  var selectedValue =  radioButtons.last().val();
  radioButtons.not($("#" + radioButtons.last().attr('id'))).filter( function(index) {
    return $(this).val() == selectedValue;
  }).attr('checked', true);
}