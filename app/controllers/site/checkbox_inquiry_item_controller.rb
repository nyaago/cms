# = SiteAdmin::CheckboxInquiryItemController
# チェックボックス問い合わせ項目の編集
class SiteAdmin::CheckboxInquiryItemController < SiteAdmin::BaseInquiryItemController
  
  protected
  
  def record_parameter_name
    :checkbox_inquiry_item
  end
  
end
