# = SiteAdmin::TextInquiryItemController
# Radio button問い合わせ項目の編集
class SiteAdmin::TextInquiryItemController < SiteAdmin::BaseInquiryItemController
  
  protected
  
  def record_parameter_name
    :text_inquiry_item
  end
  
end
