# = Category::IsHome
# トップ（ホーム）ページ区分
module Category
  
  module IsHome
    
    # 翻訳リソースのスコープ
    TRANSLATION_SCOPE = [:categories, :is_home]
    
    # selectボックス用のMapを返す.
    # keyが表示値,valueがコード値(1..)のHashを返す.
    def self.map_for_selection
       result = {}
       result[I18n.t 'not_home', :scope => TRANSLATION_SCOPE] = false
       result[I18n.t 'is_home', :scope => TRANSLATION_SCOPE] = true
       result
    end
   
    # 真偽値より見出し表示値を返す.
    def self.name_with_bool(b)
      I18n.t(if b then :is_home else :not_home end, 
      :scope => TRANSLATION_SCOPE)
    end
    
  end
  
end