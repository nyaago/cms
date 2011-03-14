module Validator
  
  module User
  
    # = Validator::User::AdminExist
    # サイト内に少なくとも１人の管理者が存在することの検証
    class SiteAdminExist
    
      TRANSLATION_SCOPE = [:errors, :user, :messages]
    
      def validate(record)
        return if record.is_admin
        cnt_record = ::User.select("count(*) as cnt").
                              where("is_site_admin = true ").
                              where("site_id = :site_id", :site_id => record.site_id).
                              where(if record.new_record? then "1 = 1" else "id <> :id" end,
                                    :id => record.id).first
        if cnt_record.cnt == 0
          record.errors[:base] << I18n.t(:site_admin_exist, 
                                        :scope => TRANSLATION_SCOPE)
        end
      end  
    end

  end

end
