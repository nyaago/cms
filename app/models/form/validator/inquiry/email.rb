module Form
  module Validator
    module Inquiry
      
      # = Form::Validator::Inquiry::Email
      # 問い合わせフォームのメイルアドレス項目の検証.
      # Form::Inquiry モデルで使用
      class Email

        # 
        TRANSLATION_SCOPE = [:errors, :form, :inquiry, :messages]
        
        def validate(record)
          record.inquiry_items.each do |site_inquiry_item|
            inquiry_item = site_inquiry_item.inquiry_item
            if inquiry_item.class.name == "EmailInquiryItem"
              attribute = "item_#{site_inquiry_item.id}"
              value = record.send(attribute)
              unless value.blank?
                regexp = Regexp.new('^(?:[^@.<>\)\(\[\]]{1}[^@<>\)\(\[\]]+[^@.<>\)\(\[\]]{1})@' + 
                "(?:[a-zA-Z]{1}[-a-zA-Z0-9]+\.)+[a-zA-Z]{1}[-a-zA-Z0-9]+$")
                unless regexp.match(value)
                  record.errors[attribute] << I18n.t(:invalid_email_address, 
                  :scope => TRANSLATION_SCOPE)
                end
              end
            end
          end
          
        end
      end
      
    end
  end
end