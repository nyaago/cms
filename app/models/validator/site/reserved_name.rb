module Validator
  
  module Site
  
    # = Validator::Site::Reserved
    # 投稿設定 - pop3設定の整合性のValidator
    class ReservedName

      @@reserved = ['site', 'admin', 'pages', 'blogs', 'users']
    
      TRANSLATION_SCOPE = [:errors, :site,:messages]
    
      def validate(record)
        if @@reserved.include?(record.name)
          record.errors[:base] << I18n.t(:reserved_name, 
                                        :scope => TRANSLATION_SCOPE)
        end
      end  
    end

  end

end
