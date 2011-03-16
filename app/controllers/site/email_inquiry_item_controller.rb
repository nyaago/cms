# = Site::EmailInquiryItemController
#  EMail 問い合わせ項目の編集
class Site::EmailInquiryItemController < Site::BaseInquiryItemController
  
  protected
  
  def record_parameter_name
    :email_inquiry_item
  end
  
end
