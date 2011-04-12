module Validator
  
  module Article
  
    # = Validator::Article::PageLimit
    # 公開ページ数の制限のValidator
    class PageLimit
      

      # 公開記事制限数
      # TODO - System情報から参照する..
      LIMIT_VALUE = 6
      class << self

        attr_accessor :limit_value
        
      end
      self.limit_value = LIMIT_VALUE
    
      TRANSLATION_SCOPE = [:errors, :article,:messages]
    
      def validate(record)
        return if record.published.blank? && record.published.blank?

        article_count = record.site.pages.select("count(*) as article_count").
                          where(" (published = true " +
                                " or " +
                                " published_from is not null" +
                                " ) " +
                                if record.new_record? then 
                                  '' 
                                else 
                                  " and id <> #{record.id}" 
                                end,
                                :site_id => record.site_id).first
        if !article_count.nil? &&  article_count.article_count >= self.class.limit_value
          record.errors[:base] << I18n.t(:page_limit, 
                                        :scope => TRANSLATION_SCOPE)
        end
      end  
    end

  end

end
