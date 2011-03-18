module Form
  module Validator
    module Inquiry
      
      # = Form::Validator::Inquiry::Required
      # 問い合わせフォームの必須入力項目の検証.
      # Form::Inquiry モデルで使用
      class Required
        
        TRANSLATION_SCOPE = [:errors, :form, :inquiry, :messages]
        
        def validate(record)
     
          record.inquiry_items.each do |site_inquiry_item|
            if site_inquiry_item.required
              attribute = "item_#{site_inquiry_item.id}"
              value = record.send(attribute)
              if value.blank? 
                record.errors[attribute] << I18n.t(:required, :scope => TRANSLATION_SCOPE)
              end
            end
          end
        end  # def
      
      end # class
      
    end
  end
end