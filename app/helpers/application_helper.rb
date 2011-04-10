# == ApplicationHelper
# view で使用する helperメソッドを定義
module ApplicationHelper
  
  # site 固有で必要なstylesheet tag を得る
  def site_stylesheet_link_tags(options)
    result = []
    if !@site.nil? && !@site.site_layout.nil?
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
    else
      ''
    end
    if defined?(@article) && !@article.nil? && !@article.column_layout.blank? 
      result << stylesheet_link_tag(@article.column_layout, options)
    end

    result.join('').html_safe

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
  # themeとして、eye_catch のテンプレート(eye_catch.html.erb)が含まれて入ればrendering,
  # なければ、defaultのテンプレート(/layouts/public/eye_catch.html.erb)をrendeting
  # == parameters
  # * area - :header / :container /  :contents
  def render_eye_catch_if_required(area)
    if !@site.nil? && !@site.site_layout.nil?
      unless  @site.site_layout.eye_catch_type_location.nil?
        if area.to_sym == @site.site_layout.eye_catch_type_location.to_sym
          if theme_partial_exist?(:eye_catch)
            p "111111"
            render_theme_partial :eye_catch
          else
            p "222222"
            render "/layouts/public/eye_catch"
          end
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
  
  # partial なテンプレートが存在するかの確認
  # == parameters
  # * template - テンプレート名. :header/:footer/:site ..
  def theme_partial_exist?(template)
    File.exist?(File.join(::Rails.root.to_s,
        "app/views",
        @site.site_layout.theme_partial_path_for_rendering("_#{template.to_s}.html.erb")))
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
  # == option　parameter
  # * :id => ul tag のid , default は :head_menu
  # * :class => ul tag のclass
  def head_menu_html(options = {})
    return '' if @site.nil?
    tag_id = if options[:id] then options[:id] else :head_menu end
    html = "<ul id='#{tag_id}'"
    if options[:class]
      html << " class='#{options[:class]}'"
    end
    html << ">"
    @site.pages.select("title, name, is_home").
                where('published = 1').
                where("is_temporary <> true or is_temporary is null").
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
    p "==================="
    matched = /^([a-z]+)\/([a-z]+)$/.match(controller)
    p matched
    scope = if matched 
      matched[1]
    else
      nil
    end
    controller = if matched 
      matched[2]
    else
      controller
    end
    p scope
    p controller
    article = if instance_variable_defined?(:@page_title) && !@page_title.nil?
      @page_title
    else
      if @article.nil?
        ''
      else
        @article
      end
    end
    p article
    if !instance_variable_defined?(:@site) || @site.nil? || @site.search_engine_optimization.nil?
      ("<title>" + 
      I18n.t(:title, :scope => [:messages, :admin])  + "|" +
      I18n.t(:title, :scope => [:messages, scope, controller])  + 
      "</title>").
      html_safe
    else
      ("<title>" +
      if article.respond_to?(:title)
        case  controller
          when 'pages' 
            @site.search_engine_optimization.page_title_text(article, @site)
          when 'blogs'
            @site.search_engine_optimization.blog_title_text(article, @site)
          else
            @site.search_engine_optimization.page_title_text(
            I18n.t(:title, :scope => [:messages, scope, controller]), @site)
  #          @site.title + "|" + I18n.t(:title, :scope => [:messages, scope, controller]) 
        end
      else
        @site.search_engine_optimization.page_title_text(
        I18n.t(:title, :scope => [:messages, scope, controller]), @site)
      end +
      "</title>").html_safe
    end
  end
  
  # not found ページのタイトルタグを返す
  def not_found_title_tag
    ("<title>" +
    if self.instance_variable_defined?(:@site) && 
          !@site.nil? && !@site.search_engine_optimization.nil?
      @site.search_engine_optimization.not_found_title_text(request)
    else
      "404 Not Found"
    end +
    "</title>").html_safe
  end

  # request url
  def request_url
    request.request_uri
  end
    

  # keywords の meta タグを返す
  def meta_keywords_tag
    controller = params[:controller]
    article = if @article.nil?
      Article.new(:ignore_meta => false)
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
      Article.new
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
  
  # 日時を設定されている日付け書式で返す
  def format_date(time)
    return '' unless time.respond_to?(:strftime)
    if @site.site_setting.nil? || @site.site_setting.date_format.nil?
      time.strftime('%Y/%m/%d')
    else
      time.strftime(@site.site_setting.date_format)
    end
  end

  # 日時を設定されている日付け書式で返す
  def format_time(time)
    return '' unless time.respond_to?(:strftime)
    if @site.site_setting.nil? || @site.site_setting.time_format.nil?
      time.strftime('%H:%M')
    else
      time.strftime(@site.site_setting.time_format)
    end
  end
  
  # 日時を設定されている月の書式 で返す
  # see config/locales/<lang>.yml の <lang>.month.<time|date>.formats.<format>
  # == parameter
  # * time 時間or日付け(Time or Date オブジェクト)
  # * format フォーマット . :default | :short | :long
  def localize_month(time, format = :default)
    I18n.localize(time, :format => format, :scope => [:month])
  end
  
  # アクセス解析のjavascriptを挿入する
  def analystic_javascript_tag
    if @site.site_setting.nil? || @site.site_setting.analytics_script.blank?
      ""
    else
      javascript_tag(@site.site_setting.analytics_script)
    end
  end

  # editor の投稿欄の大きさ(行数)
  def editor_row_count
    if @site.post_setting.nil? || @site.post_setting.editor_row_count.blank?
      10
    else
      @site.post_setting.editor_row_count
    end
  end

  # widget の rendering
  # templateとして /widget/_<モデルクラス名をunderscore形式に変換したもの>　が読み込まれる.
  # そのtemplate内では、変数名 @widget でレコードを参照できる.
  # == parameters
  # * widget - widget モデルレコード
  def render_widget(widget)
    @widget = widget
    render "/widget/#{@widget.class.name.underscore.sub(/_widget$/, '')}"
  end
  
  # side の widget の 配列を返す
  def side_widgets
    @side_widgets
  end
  
  # footer の widget の 配列を返す
  def footer_widgets
    @footer_widgets
  end

  # （対応している）ブラウザのアドレスバーにrssのリンクが表示されるようにするための
  # linkタグを返す
  # 例.
  # rss_link_for_addressbar =>
  # <link rel='alternate' type='application/rss+xml' title='RSS'  href='http://<host>/<site>/articles/index.rss' />
  def rss_link_for_addressbar
    
    format = if @site.view_setting && @site.view_setting.rss_type == "atom"
      "atom"
    else
      "rss"
    end
    
    "<link rel='alternate' type='application/rss+xml' title='RSS' " +
    " href='#{request.protocol}#{request.host_with_port}" + 
    "#{url_for(:controller => 'articles', :action => 'index', :site => @site.name, :format => format)}' />".
    html_safe
    
  end

  # rss へのlinkタグを表示
  # option tag には以下のものを指定可能
  # * :image => アイコン画像へのパス
  # * :text => テキスト, または atlテキスト
  # 例
  # rss_link :image => '/rss.png' :text => 'RSS表示'
  #   => <a href="http://<host>/<site>/articles/index.rss"><img alt="RSS表示" src="/rss.png" /></a>
  # rss_link :text => "RSS表示"
  #   => <a href="http://<host>/<site>/articles/index.atom">RSS表示</a>
  def rss_link(options)
    format = if @site.view_setting && @site.view_setting.rss_type == "atom"
      "atom"
    else
      "rss"
    end

    link_to(
    if options[:image]  
      image_tag(options[:image], 
      :alt => if options[:text]  
                options[:text] 
              else 
                'RSS' 
              end )
    else  
      if options[:text]  
        options[:text] 
      else 
        'RSS' 
      end
    end,
    request.protocol + request.host_with_port + 
    url_for(:controller => 'articles', :action => 'index', :site => @site.name, :format => format)
    )
  end
  
  #  問い合わせページへのリンク
  # option tag には以下のものを指定可能
  # * :image => アイコン画像へのパス
  # * :text => テキスト, または atlテキスト
  # 例
  # inquiry_link :image => '/inquiry.png' :text => '問い合わせ'
  #   => <a href="http://<host>/<site>/inquiry/index"><img alt="問い合わせ" src="/inquiry.png" /></a>
  # inquiry_link :text => "問い合わせ"
  #   => <a href="http://<host>/<site>/inquiry/index">問い合わせ</a>
  def inquiry_link(options = {})
    link_to(
    if options[:image]  
      image_tag(options[:image], 
      :alt => if options[:text]  
                options[:text] 
              else 
                'Inquiry' 
              end )
    else  
      if options[:text]  
        options[:text] 
      else 
        'Inquiry' 
      end
    end,
    request.protocol + request.host_with_port + 
    url_for(:controller => 'inquiry', :action => 'index', :site => @site.name)
    ) 
  end
  
  # 各widgetの　rendering
  # == parameters
  # * widgets - widget モデルレコードの array
#  def render_widgets(widgets)
#    widgets.each do |widget|
#      render_widget widget
#    end
#  end

  
end
