module ApplicationHelper
  
  # site 固有で必要なstylesheet tag を得る
  def site_stylesheet_link_tags(options)
    if !@site.nil? && !@site.site_layout.nil?
      result = []
      # theme のcss
      result << stylesheet_link_tag(@site.site_layout.theme_stylesheet_url)
      # 各デザイン設定のcss
      Layout::DefinitionArrays.layout_classes.each do |clazz|
        if @site.site_layout.respond_to?(clazz.attribute_name)
          path = clazz.css_path(@site.site_layout.send(clazz.attribute_name))
          if File.file?(path)
            result << stylesheet_link_tag(
            clazz.css_url(@site.site_layout.send(clazz.attribute_name)),
            options)
          end
        end
      end
      result.join('').html_safe
    else
      ''
    end
  end
  

  # site_layoutモデルに定義されているタイトルタグフォーマットより、タイトルに表示する値を得る
  # ==　置換される文字
  # * %site_title%, %blog_title% -> サイトタイトル
  # *　%page_title%, %article_title% -> ページタイトル
  # == params
  # * default_article_title  - 記事のインスタンス(@article)がない場合にページタイトル使用される文字列値
  # * article - 記事オブジェクト, title属性,それがなければto_sの値を参照
  def title_tag_text(default_article_title = nil)
    return '' if !self.instance_variable_defined?(:@site)
    if self.instance_variable_defined?(:@article)
      @site.site_layout.title_tag_text(@article)
    else
      @site.site_layout.title_tag_text(default_article_title.to_s)
    end
  end

  # 指定したareaにeye_catchをrenderingすべきであればrenderingする.
  # site_layoutモデルを参照して判定する
  def render_eye_catch_if_require(area)
    if !@site.nil? && !@site.site_layout.nil?
      unless  @site.site_layout.eye_catch_type_location.nil?
        if area.to_sym == @site.site_layout.eye_catch_type_location.to_sym
          render "/layouts/public/eye_catch"
        end
      end
    end
  end
  
  def render_theme_partial(template)
    render @site.site_layout.theme_partial_path_for_rendering(template)
  end
  
end
