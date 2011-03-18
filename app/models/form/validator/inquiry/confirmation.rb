module Form
  module Validator
    module Inquiry
      
      # = Form::Validator::Inquiry::Confirmation
      # 問い合わせフォーム- 確認入力が必要な場合に値が等しいかを検証.
      # Form::Inquiry モデルで使用
      class Confirmation
        
        TRANSLATION_SCOPE = [:errors, :form, :inquiry, :messages]
        
        def validate(record)
     
          record.inquiry_items.each do |site_inquiry_item|
            inquiry_item = site_inquiry_item.inquiry_item
            return inquiry_item.nil?
            if inquiry_item.respond_to?(:comfirmation_required)
              if inquiry_item.send(:comfirmation_required)
                attribute = "item_#{site_inquiry_item.id}"
                if record.send(attribute) != record_send("#{attribute}_confirmation")
                  record.errors[attribute] << I18n.t(:invalid_confirmation, 
                  :scope => TRANSLATION_SCOPE)
                end
              end
          end
        end # def

      end  # class
      
    end
  end
end