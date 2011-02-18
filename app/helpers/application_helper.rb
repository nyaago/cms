# == ApplicationHelper
# view で使用する helperメソッドを定義
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

  # 指定したareaにeye_catchをrenderingすべきであるか?
  # site_layoutモデルを参照して判定する
  # == parameters
  # * area - :header / :container /  :contents
  def eye_catch_required?(area)
    !@site.nil? && !@site.site_layout.nil? && 
        !site.site_layout.eye_catch_type_location.nil? &&
        area.to_sym == @site.site_layout.eye_catch_type_location.to_sym
  end

  # 指定したareaにeye_catchをrenderingすべきであればrenderingする.
  # site_layoutモデルを参照して判定する
  # == parameters
  # * area - :header / :container /  :contents
  def render_eye_catch_if_required(area)
    if !@site.nil? && !@site.site_layout.nil?
      unless  @site.site_layout.eye_catch_type_location.nil?
        if area.to_sym == @site.site_layout.eye_catch_type_location.to_sym
          render "/layouts/public/eye_catch"
        end
      end
    end
  end
  
  # partial なテンプレートをrenderingする
  # == parameters
  # * template - テンプレート名. :header/:footer/:site ..
  def render_theme_partial(template)
    render @site.site_layout.theme_partial_path_for_rendering(template)
  end
  
  # header 画像のhtmlタグを返す
  def header_image_tag
    if !@site.nil? && !@site.site_layout.nil? && !@site.site_layout.header_image_url.blank?
      image_tag(@site.site_layout.header_image_url, :alt => @site.title)
    else
      ''
    end
  end

  # footer 画像のhtmlタグを返す
  def footer_image_tag
    if !@site.nil? && !@site.site_layout.nil? && !@site.site_layout.footer_image_url.blank?
      image_tag(@site.site_layout.footer_image_url, :alt => @site.title)
    else
      ''
    end
  end
  
  # home の urlを返す
  def home_url
    url = url_for(:controller => :pages, 
                  :action => :show, 
                  :site => @site.name, 
                  :page => nil)
  end
  
  # footer 画像のhtmlタグを返す. ホームリンク表示が有効の場合はリンクを含める
  def logo_image_tag
    if !@site.nil? && !@site.site_layout.nil? && !@site.site_layout.logo_image_url.blank?
      if @site.site_layout.global_navigation == 'home_link'
        link_to(image_tag(@site.site_layout.logo_image_url, :alt => @site.title), home_url)
      else
        image_tag(@site.site_layout.logo_image_url, :alt => @site.title)
      end
    else
      ''
    end
  end
  
  # homeリンク表示が指定されているか?
  def home_link_required?
    !@site.nil? && !@site.site_layout.nil? && 
                  @site.site_layout.global_navigation == 'home_link'
  end
    
  
  # homeリンクへ表示する指定がされていれば home への linkを表示する
  # == parameters
  # * title - リンクテキスト
  def home_link_if_required(title)
    if !@site.nil? && !@site.site_layout.nil?
      if @site.site_layout.global_navigation == 'home_link'
        link_to(title, home_url)
      else
        ''
      end
    else
      ''
    end
  end
  
  # 背景のcssを返す
  def background_css
    return '' if @site.nil? && @site.site_layout.nil?
    content = "body { \n"
    content <<  unless @site.site_layout.background_image_url.blank?
      "background-image: url(#{@site.site_layout.background_image_url});\n" <<
      "background-repeat: " <<
      if @site.site_layout.background_repeat.blank? 
        "repeat"
      else
        @site.site_layout.background_repeat 
      end <<
        "; \n"
    else
      ''
    end
    content << unless @site.site_layout.background_color.blank?
      "background-color: #{@site.site_layout.background_color}\n"
    else
      ''
    end
    content << "}\n"
  end
  
  # head menu のhtmlを返す
  # メニューは,idをhead_menu とするul タグ. 各メニュー項目はliタグとなる
  def head_menu_html
    return '' if @site.nil?
    html = '<ul id="head_menu">'
    @site.pages.select("title, name, is_home").
                where('published = 1').
                order('menu_order').each do |page|
      url = url_for(:controller => :pages, 
                    :action => :show, 
                    :site => @site.name, 
                    :page => if page.is_home then nil else page.name  end)
      html << "<li><a href='#{url}'>" <<
            page.title <<
            "</a></li>\n"
    end
    html << '</ul>'
    html.html_safe
  end
  
  # title タグを返す
  def title_tag
    controller = params[:controller]
    article = if @article.nil?
      ''
    else
      @article
    end
    return '<title></title>' if @site.nil? || @site.search_engine_optimization.nil?
    ("<title>" +
    case  controller
      when 'pages'
        @site.search_engine_optimization.page_title_text(article)
      when 'blogs'
        @site.search_engine_optimization.blog_title_text(article)
      else
        @site.title
    end +
    "<title>").html_safe
  end

  # keywords の meta タグを返す
  def meta_keywords_tag
    controller = params[:controller]
    article = if @article.nil?
      ''
    else
      @article
    end
    return '' if @site.nil? || @site.search_engine_optimization.nil?
    ('<meta name="keywords" content="' +
    case  controller
      when 'pages'
        (if article.ignore_meta == false && 
              !@site.search_engine_optimization.page_keywords.blank?
          @site.search_engine_optimization.page_keywords
        end || '') +
        (if article.ignore_meta == false && 
              !@site.search_engine_optimization.page_keywords.blank? &&
              !article.meta_keywords.blank?
          ','
        end || '') +
        (unless article.meta_keywords.blank? 
          article.meta_keywords
        end || '')
      when 'blogs'
        (if article.ignore_meta == false && 
              !@site.search_engine_optimization.blog_keywords.blank?
          @site.search_engine_optimization.blog_keywords
        end || '') +
        (if article.ignore_meta == false && 
              !@site.search_engine_optimization.blog_keywords.blank? &&
              !article.meta_keywords.blank? 
          ','
        end || '') +
        (unless article.meta_keywords.blank? 
          article.meta_keywords
        end || '')
      else
        (if !@site.search_engine_optimization.page_keywords.blank?
          @site.search_engine_optimization.page_keywords
        end || '')
    end + 
    '"/>').html_safe
  end

  # description の meta タグを返す
  def meta_description_tag
    controller = params[:controller]
    article = if @article.nil?
      ''
    else
      @article
    end
    return '' if @site.nil? || @site.search_engine_optimization.nil?
    ('<meta name="description" content="' +
    case  controller
      when 'pages'
        (if article.ignore_meta == false && 
              !@site.search_engine_optimization.page_description.blank?
          @site.search_engine_optimization.page_description
        end || '') +
        (if article.ignore_meta == false && 
              !@site.search_engine_optimization.page_description.blank? &&
              !article.meta_description.blank?
          ','
        end || '') +
        (unless article.meta_description.blank? 
          article.meta_description
        end || '') 
      when 'blogs'
        (if article.ignore_meta == false && 
              !@site.search_engine_optimization.blog_description.blank?
          @site.search_engine_optimization.blog_description
        end || '') +
        (if article.ignore_meta == false && 
              !@site.search_engine_optimization.blog_description.blank? &&
              !article.meta_description.blank? 
          ','
        end || '') +
        (unless article.meta_keywords.blank? 
          article.meta_description
        end || '') 
      else
        (if !@site.search_engine_optimization.page_keywords.blank?
          @site.search_engine_optimization.page_keywords
        end || '') 
      end + 
      '"/>').html_safe

  end
  
end
