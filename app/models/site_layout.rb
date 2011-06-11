# = SiteLayout
# サイトレイアウトのモデル
class SiteLayout < ActiveRecord::Base
  
  TITLE_REPLACE_MAP_FOR_ARTICLE = {
    '%article_title%' => [:title, :to_s],
    '%page_title%' => [:title, :to_s],
  }

  TITLE_REPLACE_MAP_FOR_SITE = {
    '%site_title%' => :title,
    '%blog_title%' => :title,
  }
  
  # サイトへの所属関連
  belongs_to :site
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  
  # 作成時のFilter. default値の設定
  before_create :set_default!
  
  # formatに関する属性について.そのformatの属性への値設定
  before_update :set_format!
  # locationに関する属性について.そのformatの属性への値設定
  before_update :set_location!
  
  # @deprecated
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
  
  # theme の cssのファイルシステム上の場所を返す
  # なければnilを返す
  # 場所は、"/public/themes/<theme>/stylesheets/theme.css" となる
  def theme_stylesheet_path
    dir = 
    if theme.nil? 
      nil
    else 
      path = ::Rails.root.to_s + "/public/themes/#{theme}/stylesheets/theme.css"
      if File.file?(path)
        path
      else
        nil
      end
    end
  end

  # default の themeの場所を返す
  # "/public/themes/default/stylesheets/theme.css"  となる
  def default_theme_stylesheet_path
    ::Rails.root.to_s + "/public/themes/default/stylesheets/theme.css" 
  end

  # themeのstylesheet があるか/ないか ?
  def theme_stylesheet_exists?
    !theme_stylesheet_path.nil?
  end
  
  # theme の cssのurlを返す.
  # themeに対応するテーマがなければ,default の theme のurlを返す.
  def theme_stylesheet_url
    if theme_stylesheet_exists?
      "/themes/#{theme}/stylesheets/theme.css"
    else
      "/themes/default/stylesheets/theme.css"
    end
  end
  
  # themeの layout templateのファイルシステム上の場所を返す
  # "<Rails_Root>/app/views/layouts/themes/#{theme}/application.html.erb"　となる
  def theme_layout_path
    if theme.nil? 
      nil
    else 
      path = ::Rails.root.to_s + "/app/views/layouts/themes/#{theme}/application.html.erb"
      if File.file?(path)
        path
      else
        nil
      end
    end
  end

  # themeの 部分レイアウトlayout ファイルシステム上の場所を返す
  def theme_partial_path(template)
    if theme.nil? 
      nil
    else 
      path = ::Rails.root.to_s + "/app/views/layouts/themes/#{theme}/_#{template}.html.erb"
      if File.file?(path)
        path
      else
        nil
      end
    end
  end

  
  # themeのlayout template があるか/ないか ?
  def theme_layout_exists?
    !theme_layout_path.nil?
  end

  # themeのpartial template があるか/ないか ?
  def theme_partial_exists?(template)
    !theme_partial_path(template).nil?
  end
  
  # render method の :layout optionに渡すパス
  def theme_layout_path_for_rendering
    if theme_layout_exists?
      "themes/#{theme}/application.html.erb"
    else
      "themes/default/application.html.erb"
    end
  end



  # render method の :layout optionに渡すパス
  def theme_partial_path_for_rendering(template)
    if theme_partial_exists?(template)
      "layouts/themes/#{theme}/#{template}"
    else
      "layouts/themes/default/#{template}"
    end
  end
  
  
  protected
  
  # default値の設定
  def set_default!
    self.theme = 'default'
    self.eye_catch_type = 'none'
    self.font_size = 'default'
    self.skin_color = 'default'
    self.column_layout = 'menu_on_left'
    self.global_navigation = 'home_link'
    self.background_repeat = 'repeat'
    self.inquiry_link_position = 'on_menu'
    self.background_color = ''
    true
  end

  # formatに関する属性について.そのformatの属性への値設定
  # <attr_name>属性の値に設定されている値をもとに<attr_name>_format 属性への値設定を行う.
  # config/layout/<attr_name>.yml の定義とマッピングして行う。
  #   (現行では,title_tag属性の値に対応するtitle_tag_format属性への値設定)
  def set_format!
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
  # <attr_name>属性の値に設定されている値をもとに<attr_name>_location 属性への値設定を行う.
  # config/layout/<attr_name>.yml の定義とマッピングして行う。
  #   (現行では,eye_catch_type属性の値に対応するeye_catch_type_location属性への値設定)
  def set_location!
    defs = Layout::DefinitionArrays.new
    ["eye_catch_type"].
    each do |attr_name|
      attr_array = defs.send(attr_name.pluralize)
      selected_attr = attr_array.find_by_name(self.send(attr_name))
      selected_attr = attr_array.find_default if selected_attr.nil? 
      self.send(attr_name + "_location=", selected_attr.location)
    end
    true
  end

  
end
