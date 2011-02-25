module Validator
  
  module PostSetting
  
    # = Validator::PostSetting::Post3Consistency
    # 投稿設定 - pop3設定の整合性のValidator
    class Pop3Consistency

    
      TRANSLATION_SCOPE = [:errors, :post_setting,:messages]
    
      def validate(record)
        if (!record.pop3_host.blank? || !record.pop3_login.blank?  || !record.pop3_password.blank?) &&
          (record.pop3_host.blank? || record.pop3_login.blank?  || record.pop3_password.blank?)
        
          record.errors[:base] << I18n.t(:pop3_consistency, 
                                        :scope => TRANSLATION_SCOPE)
        end
      end  
    end

  end

end
