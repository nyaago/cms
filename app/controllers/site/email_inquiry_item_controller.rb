# = SiteAdmin::EmailInquiryItemController
#  EMail 問い合わせ項目の編集
class SiteAdmin::EmailInquiryItemController < SiteAdmin::BaseInquiryItemController
  
  protected
  
  def record_parameter_name
    :email_inquiry_item
  end
  
end
