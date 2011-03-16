# = Site::RadioInquiryItemController
# Radio button問い合わせ項目の編集
class Site::RadioInquiryItemController < Site::BaseInquiryItemController
  
  protected
  
  def record_parameter_name
    :radio_inquiry_item
  end
  
end
