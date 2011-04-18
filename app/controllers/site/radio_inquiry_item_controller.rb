# = SiteAdmin::RadioInquiryItemController
# Radio button問い合わせ項目の編集
class SiteAdmin::RadioInquiryItemController < SiteAdmin::BaseInquiryItemController
  
  protected
  
  def record_parameter_name
    :radio_inquiry_item
  end
  
end
