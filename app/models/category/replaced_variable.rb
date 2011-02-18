# = Category::ReplacedVariable
# 変数置換に関するmodule
# article(記事), site, request(http リクエスト)に関する変数置換を扱う
module Category
  
  module ReplacedVariable

    # 記事モデルオブジェクトに関する文字置換map
    REPLACE_MAP_FOR_ARTICLE = {
      '%article_title%' => [:title, :to_s],
      '%page_title%' => [:title, :to_s],
    }

    # サイトモデルオブジェクトに関する文字置換map
    REPLACE_MAP_FOR_SITE = {
      '%site_title%' => :title,
      '%blog_title%' => :title,
    }

    # requestオブジェトに関する文字置換map
    URL_REPLACE_MAP_FOR_REQUEST = {
      '%request_url%' => :request_uri,
      '%request_uril%' => :request_uri
    }
    
    # 記事モデルオブジェクトに関する文字置換map
    def map_for_article
      REPLACE_MAP_FOR_ARTICLE
    end
    
    # サイトモデルオブジェクトに関する文字置換map
    def map_for_site
      REPLACE_MAP_FOR_SITE
    end
    
    # requestオブジェトに関する文字置換map
    def map_for_request
      URL_REPLACE_MAP_FOR_REQUEST
    end
    
    # mapping情報を参照して、置換変数を含む文字列に対する置換結果を返す
    # == parameters
    # * s - 置換対象の文字列
    # * record - 置換される属性を含むモデルのレコード
    # * map - 置換変数のmap, key => 置換変数, value => 属性名 or 属性名の配列
    def replace_string_with_mapping(replaced_string, record, map)
      result = replaced_string
      map.each_pair do |replaced, attr_names|
        exp = Regexp.new(replaced)
        result = if attr_names.respond_to?(:each)
          attr_names.each do |attr_name|
            if record.respond_to?(attr_name)
              result =  result.gsub(exp, record.send(attr_name))
            end
          end
          result
        else
          exp = Regexp.new(replaced)
          result.gsub(exp, record.send(attr_names.to_s))
        end      
      end
      result 
    end

  end

end