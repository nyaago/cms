# = Site::TextInquiryItemController
# Radio button問い合わせ項目の編集
class Site::TextInquiryItemController < Site::BaseInquiryItemController
  
  protected
  
  def record_parameter_name
    :text_inquiry_item
  end
  
end
