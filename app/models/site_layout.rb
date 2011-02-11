class SiteLayout < ActiveRecord::Base
  
  TITLE_REPLACE_MAP_FOR_ARTICLE = {
    '%article_title%' => [:title, :to_s],
    '%page_title%' => [:title, :to_s],
  }

  TITLE_REPLACE_MAP_FOR_SITE = {
    '%site_title%' => :title,
    '%blog_title%' => :title,
  }
  
  
  belongs_to :site
  
  # 作成時のFilter. default値の設定
  before_create :set_default
  
  # formatに関する属性について.そのformatの属性への値設定
  before_update :set_format
  # locationに関する属性について.そのformatの属性への値設定
  before_update :set_location
  
  # タイトルタグフォーマット属性より、タイトルに表示する値を得る
  # self::TITLE_REPLACE_MAP_FOR_ARTICLEで定義されている置換変数を引数の記事のタイトルに置換
  # self::TITLE_REPLACE_MAP_FOR_SITEで定義されている置換変数を引数のサイトのタイトルに置換
  # == params
  # * article - 記事オブジェクト, title属性,それがなければto_sの値を参照
  def title_tag_text(article)
    result = title_tag_format
    TITLE_REPLACE_MAP_FOR_ARTICLE.each_pair do |replaced, attr_names|
      exp = Regexp.new(replaced)
      attr_names.each do |attr_name|
        if article.respond_to?(attr_name)
          result = result.gsub(exp, article.send(attr_name))
          break result
        end
      end
    end
    TITLE_REPLACE_MAP_FOR_SITE.each_pair do |replaced, attr_name|
      exp = Regexp.new(replaced)
      result = result.gsub(exp, self.site.send(attr_name))
    end
    result
  end
  
  protected
  
  # default値の設定
  def set_default
    self.theme = 'default'
    self.eye_catch_type = 'none'
    self.font_size = 'default'
    self.skin_color = 'default'
    self.column_layout = 'menu_on_left'
    self.global_navigation = 'home_link'
  end

  # formatに関する属性について.そのformatの属性への値設定
  #   (現行では,title_tag属性の値に対応するtitle_tag_format属性への値設定)
  def set_format
    defs = Layout::DefinitionArrays.new
    ["title_tag"].
    each do |attr_name|
      attr_array = defs.send(attr_name.pluralize)
      selected_attr = attr_array.find_by_name(self.send(attr_name))
      selected_attr = attr_array.find_default if selected_attr.nil? 
      self.send(attr_name + "_format=", selected_attr.format)
    end
    
  end

  # locationに関する属性について.そのlocationの属性への値設定
  #   (現行では,eye_catch_type属性の値に対応するeye_catch_type_format属性への値設定)
  def set_location
    defs = Layout::DefinitionArrays.new
    ["eye_catch_type"].
    each do |attr_name|
      attr_array = defs.send(attr_name.pluralize)
      selected_attr = attr_array.find_by_name(self.send(attr_name))
      selected_attr = attr_array.find_default if selected_attr.nil? 
      self.send(attr_name + "_location=", selected_attr.location)
    end
    
  end

  
end
