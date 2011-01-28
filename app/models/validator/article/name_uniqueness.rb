module Validator
  
  module Article
  
    # = Validator::Article::NameUniqueness
    # 記事の名前がサイト内で一意であるかのValidator
    class NameUniqueness
    
      TRANSLATION_SCOPE = [:errors, :messages]
    
      def validate(record)
        if ::Article.where("site_id = :site_id and name = :name " + 
                                if record.new_record? then 
                                  '' 
                                else 
                                  " and id <> #{record.id}" 
                                end,
                                :site_id => record.site_id, 
                                :name => record.name).count > 0
          record.errors[:name] << I18n.t(:uniqness_in_site, 
                                        :scope => TRANSLATION_SCOPE)
        end
      end  
    end

  end

end
