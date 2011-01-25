# = Category::HaadingLevel
# 見出しレベル
module Category
  
  module HeadingLevel
    
    # 翻訳リソースのスコープ
    TRANSLATION_SCOPE = [:categories, :heading_level]
    
    # selectボックス用のMapを返す.
    # keyが表示値,valueがコード値(1..)のHashを返す.
    def self.map_for_selection
       result = {}
       (1..3).each do |i|
         result[I18n.t 'h' + i.to_s, :scope => TRANSLATION_SCOPE] = i
       end
       result
    end
   
    # コード値より見出し表示値を返す.
    def self.name_with_id(heading_level_id)
      I18n.t('h' + heading_level_id.to_s, :scope => TRANSLATION_SCOPE)
    end
    
  end
  
end