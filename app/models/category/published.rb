# = Category::HaadingLevel
# 見出しレベル
module Category
  
  module Published
    
    # 翻訳リソースのスコープ
    TRANSLATION_SCOPE = [:categories, :published]
    
    # selectボックス用のMapを返す.
    # keyが表示値,valueがコード値(1..)のHashを返す.
    def self.map_for_selection
       result = {}
       result[I18n.t 'unpublished', :scope => TRANSLATION_SCOPE] = false
       result[I18n.t 'published', :scope => TRANSLATION_SCOPE] = true
       result
    end
   
    # 真偽値より見出し表示値を返す.
    def self.name_with_bool(b)
      I18n.t(if b then :published else :unpublished end, 
      :scope => TRANSLATION_SCOPE)
    end
    
  end
  
end