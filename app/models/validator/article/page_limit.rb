module Validator
  
  module Article
  
    # = Validator::Article::PageLimit
    # 公開ページ数の制限のValidator
    class PageLimit

      # 公開記事制限数
      # TODO - System情報から参照する..
      LIMIT_VALUE = 6
    
      TRANSLATION_SCOPE = [:errors, :article,:messages]
    
      def validate(record)
        return if !record.published 

        article_count = ::Article.select("count(*) as article_count").
                          where("site_id = :site_id " + 
                                " and published = true " +
                                " and article_type = #{::Article::TYPE_PAGE}" +
                                if record.new_record? then 
                                  '' 
                                else 
                                  " and id <> #{record.id}" 
                                end,
                                :site_id => record.site_id).first
        if !article_count.nil? &&  article_count.article_count >= LIMIT_VALUE - 1
          record.errors[:base] << I18n.t(:page_limit, 
                                        :scope => TRANSLATION_SCOPE)
        end
      end  
    end

  end

end
