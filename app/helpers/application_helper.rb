# == ApplicationHelper
# view で使用する helperメソッドを定義
module ApplicationHelper
  
  # site 固有で必要なstylesheet 各tag を得る
  # 選択されているthemeのstylesheer、各レイアウト設定に対応するstylesheetを読み込みタグ
  # が生成される.
  # == parameters
  # * options - 以下のoptionを含むハッシュ
  #   :media => stylesheetを適用するmedia :all, :print, ..
  # == 例
  # site_stylesheet_link_tags :media => :all
  # =>
  # <link href="/themes/default/stylesheets/theme.css?1300957864" media="screen" rel="stylesheet" type="text/css" />
  # <link href="/eye_catch_types/header_area_banner/eye_catch_type.css?1298381634" media="all" rel="stylesheet" type="text/css" />
  # <link href="/column_layouts/menu_on_left/column_layout.css?1298381634" media="all" rel="stylesheet" type="text/css" />
  # <link href="/font_sizes/small/font_size.css?1298381634" media="all" rel="stylesheet" type="text/css" />
  # <link href="/global_navigations/home_link/global_navigation.css?1298381634" media="all" rel="stylesheet" type="text/css" />
  # <link href="/skin_colors/green/skin_color.css?1298381634" media="all" rel="stylesheet" type="text/css" /> 
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
      Layout::DefinitionArrays.layout_classes.each do |clazz|
        if @site.site_layout.respond_to?(clazz.attribute_name)
          path = clazz.css_path(@site.site_layout.send(clazz.attribute_name), @site.site_layout.theme)
          if File.file?(path)
            result << stylesheet_link_tag(
                      clazz.css_url(@site.site_layout.send(clazz.attribute_name), @site.site_layout.theme),
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
  # rendering すべきであれば true, そうでなければfalseを返す.
  # site_layoutモデルを参照して判定する
  # == parameters
  # * area - :header / :container /  :contents
  def eye_catch_required?(area)
    !@site.nil? && !@site.site_layout.nil? && 
        !@site.site_layout.eye_catch_type_location.nil? &&
        area.to_sym == @site.site_layout.eye_catch_type_location.to_sym
  end

  # 指定したareaにeye_catchをrenderingすべきであればrenderingする.
  # site_layoutモデルを参照して判定する
  # themeとして、eye_catch のテンプレート(eye_catch.html.erb)が含まれて入ればrendering,
  # なければ、defaultのテンプレート(/layouts/public/eye_catch.html.erb)をrendeting
  # == parameters
  # * area - :header / :container /  :contents
  def render_eye_catch_if_required(area)
    if eye_catch_required?(area)
      if theme_partial_exist?(:eye_catch)
        render_theme_partial :eye_catch
      else
        render "/layouts/public/eye_catch"
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
  # テンプレートが存在すれば true, そうでなければfalseを返す.
  # == parameters
  # * template - テンプレート名. :header/:footer/:site ..
  def theme_partial_exist?(template)
    File.exist?(File.join(::Rails.root.to_s,
        "app/views",
        @site.site_layout.theme_partial_path_for_rendering("_#{template.to_s}.html.erb")))
  end
  
  # header 画像のhtmlタグを返す
  # == parameters
  # * options - 追加するタグ属性のハッシュ
  def header_image_tag(options = {})
    if instance_variable_defined?(:@article) && @article && !@article.header_image_url.blank? 
      options[:alt] = @article.title
      image_tag(@article.header_image_url, options)
    elsif !@site.nil? && !@site.site_layout.nil? && !@site.site_layout.header_image_url.blank?
      options[:alt] = @site.title
      image_tag(@site.site_layout.header_image_url, options)
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
  # <site>/pages/<page name> の形式で返す.
  def home_url
    url = url_for(:controller => :pages, 
                  :action => :show, 
                  :site => @site.name, 
                  :page => nil)
  end
  
  # ホームリンクへのリンクを含むlogo画像のhtmlタグを返す. 
  def logo_image_tag
    if !@site.nil? && !@site.site_layout.nil? && !@site.site_layout.logo_image_url.blank?
      link_to(image_tag(@site.site_layout.logo_image_url, :alt => @site.title), home_url)
    else
      ''
    end
  end
  
  # header 画像の url
  def header_image_url
    if instance_variable_defined?(:@article) && @article && !@article.header_image_url.blank? 
      @article.header_image_url
    elsif !@site.nil? && !@site.site_layout.nil? && !@site.site_layout.header_image_url.blank?
      @site.site_layout.header_image_url
    else
      ''
    end
    
  end
  
  # header の画像を表示するためのbackground-image スタイルを返すを返す
  def header_image_style
    if instance_variable_defined?(:@article) && @article && !@article.header_image_url.blank? 
      "background-image:url('#{@article.header_image_url}');" 
    elsif !@site.nil? && !@site.site_layout.nil? && !@site.site_layout.header_image_url.blank?
      "background-image:url('#{@site.site_layout.header_image_url}');" 
    else
      ""
    end
  end

  # footer の画像を表示するためのbackground-image スタイルを返すを返す
  def footer_image_style
    if @site.site_layout && @site.site_layout.footer_image_url
      "background-image:url('#{@site.site_layout.footer_image_url}');"
    else
      ""
    end
  end

  # logo の画像を表示するためのbackground-image プロパティを返す
  def logo_image_style
    if @site.site_layout && @site.site_layout.logo_image_url
      "background-image:url('#{@site.site_layout.logo_image_url}');"
    else
      ""
    end
  end
  
  # homeリンク表示が指定されているか?
  # homeリンク表示なら true, そうでなければfalseを返す.
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
  
  # 背景のcss プロパティの記述を返す
  # 背景画像が指定されている場合は、background-image と background-repeat、
  # 色が指定されている場合は、background-colorの内容を返す.
  def background_css
    return '' if @site.nil? && @site.site_layout.nil?
#    content = "body { \n"
    content = ""
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
 #   content << "}\n"
  end
  
  # menu のhtmlを返す
  # メニューはulタグ. それに含まれる 各メニュー項目はliタグとなる
  # 2011/4 現在 では、公開ページ記事へのリンクを含むものとなる.
  # == option　parameter
  # * :id => ul tag のid.加えてliタグのidを<:id>_<記事名>とする. default は :head_menu, 
  # * :class => ul tag のclass
  # == 例
  # * menu_html :id => :header_menu, :class => :menu  =>
  # <ul id='header_menu' class='menu'><li><a href='/moomin'>ホーム</a></li> 
  # <li id='header_menu_page1'><a href='/moomin/pages/page1'>Page1</a></li> 
  # <li id='header_menu_page1'><a href='/moomin/pages/page2'>Page2</a></li> 
  # </ul>  #       
  def menu_html(options = {})
    return '' if @site.nil?
    tag_id = if options[:id] then options[:id] else :head_menu end
    html = "<ul id='#{tag_id}'"
    if options[:class]
      html << " class='#{options[:class]}'"
    end
    html << ">"
    @site.pages.select("title, name, is_home").
                where('published = 1').
                order('menu_order').each do |page|
      next if page.is_home && @site && @site.site_layout.global_navigation == "no_home_link"
      url = url_for(:controller => :pages, 
                    :action => :show, 
                    :site => @site.name, 
                    :page => if page.is_home then nil else page.name  end)
      li_tag_id = "#{tag_id}_#{page.name}"
      html << "<li id='#{li_tag_id}'><a href='#{url}'>" <<
            page.title <<
            "</a></li>\n"
    end
    if @site && @site.site_layout.inquiry_link_position == 'on_menu'
      url = url_for(:controller => :inquiry, 
                    :site => @site.name)
      li_tag_id = "#{tag_id}_inquiry"
      html << "<li id='#{li_tag_id}'><a href='#{url}'>" <<
            I18n.t(:title, :scope => [:messages, :inquiry] ) <<
            "</a></li>\n"
    end
    html << '</ul>'
    html.html_safe
  end
  
  # 問い合わせリンクが指定したareaに配置することが要求されているかどうか?
  # == parameters 
  # * area - :side | :menu (サイドエリア or ナビゲーションメニュー)
  def inquiry_link_required_on?(area)
    if @site && @site.site_layout 
      if area == :side
        @site.site_layout.inquiry_link_position == 'on_side'
      elsif area == :menu
        @site.site_layout.inquiry_link_position == 'on_menu'
      else
        false
      end
    else
      false
    end
  end
  
  # title タグを返す.
  # == 値 =>
  # 公開ページのうちページ|お知らせの場合は、SEO設定(search_engine_optimization)で設定された書式での
  # 記事タイトル/サイト名を含むものとなる。
  # 公開ページのうちページ|お知らせ以外は、SEO設定(search_engine_optimization)のpage_titie_format設定された書式を使い,
  # 機能名(=記事名)/サイト名を含むものとなる。
  # サイト管理の場合は,<サイト名>|<機能名>となる。
  # 管理ページの場合は、管理|<機能名>となる
  def title_tag
    # page title を含むオブジェクト, いずれかの変数
    page_title_variables = [:@article ,:@month, :@page_title]
    controller = params[:controller]
    matched = /^([_a-z]+)\/([_a-z]+)$/.match(controller)
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
    page_title_container = nil
    page_title_variables.each do |instance_variable|
      if instance_variable_defined?(instance_variable) && 
          !instance_variable_get(instance_variable).nil?
        page_title_container =  instance_variable_get(instance_variable)
        break
#        if instance_variable_get(instance_variable).respond_to?(method)
#          break instance_variable_get(instance_variable).send(method)
#        end
      end
    end 
    
    article = if instance_variable_defined?(:@page_title) && !@page_title.nil?
      @page_title
    else
      if @article.nil?
        ''
      else
        @article
      end
    end

    if !instance_variable_defined?(:@site) || @site.nil? || @site.search_engine_optimization.nil?
      ("<title>" + 
      I18n.t(:title, :scope => [:messages, :admin])  + " | " +
      I18n.t(:title, :scope => [:messages, scope, controller])  + 
      "</title>").
      html_safe
    else
      ("<title>" +
      h(if page_title_container
        case  controller
          when 'pages' 
            @site.search_engine_optimization.page_title_text(page_title_container, @site)
          when 'blogs'
            @site.search_engine_optimization.blog_title_text(page_title_container, @site)
          else
            @site.search_engine_optimization.page_title_text(page_title_container, @site)
#            I18n.t(:title, :scope => [:messages, scope, controller]), @site)
        end
      else
        @site.search_engine_optimization.page_title_text(
        I18n.t(:title, :scope => [:messages, scope, controller]), @site)
      end) +
      "</title>").html_safe
    end
  end
  
  # ページタイトルを返す
  # ページ記事の場合は、記事タイトル .ただし、トップページの場合は、空白
  # それ以外の場合は、メッセージリソースの messages.<controller>.title  の値
  def page_title
    # page title を含むオブジェクト, いずれかの変数
    controller = params[:controller]
    matched = /^([_a-z]+)\/([_a-z]+)$/.match(controller)
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
    
    if instance_variable_defined?(:@article) && @article.respond_to?(:title)
      if @article.respond_to?(:is_home) && @article.is_home
        ''
      else
        @article.title
      end
    else 
      I18n.t(:title, :scope => [:messages, scope, controller])
    end
  end
  
  # 公開ページのnot found ページのタイトルタグを返す
  # == 値 =>
  # SEO設定(search_engine_optimization)で設定された書式での
  # 記事タイトル/サイト名を含むものとなる。  def not_found_title_tag
  def not_found_title_tag
    ("<title>" +
    h(if self.instance_variable_defined?(:@site) && 
          !@site.nil? && !@site.search_engine_optimization.nil?
      @site.search_engine_optimization.not_found_title_text(request)
    else
      "404 Not Found"
    end) +
    "</title>").html_safe
  end

  # request url
  def request_url
    request.request_uri
  end

  # keywords の meta タグを返す.
  # SEO設定(search_engine_optimization)に設定されているもの、
  # 記事(articles)に設定されているものを値として含むものを返す.
  def meta_keywords_tag
    controller = params[:controller]
    article = if @article.nil?
      Article.new(:ignore_meta => false)
    else
      @article
    end
    return '' if @site.nil? || @site.search_engine_optimization.nil?
    ('<meta name="keywords" content="' + 
    h(case  controller
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
    end) + 
    '"/>').html_safe
  end

  # description の meta タグを返す
  # SEO設定(search_engine_optimization)に設定されているもの、
  # 記事(articles)に設定されているものを値として含むものを返す.
  def meta_description_tag
    controller = params[:controller]
    article = if @article.nil?
      Article.new
    else
      @article
    end
    return '' if @site.nil? || @site.search_engine_optimization.nil?
    ('<meta name="description" content="' +
    h(case  controller
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
        (unless article.meta_description.blank? 
          article.meta_description
        end || '') 
      else
        (if !@site.search_engine_optimization.page_description.blank?
          @site.search_engine_optimization.page_description
        end || '') 
      end) + 
      '"/>').html_safe

  end
  
  # 日時をサイトの一般設定(site_setting)で設定されている日付け書式で返す
  # == Example
  # * format_date(Time.now) -> 現在日付けを設定されている書式で
  # * format_date(@article.updated_at) -> 記事の変更日付けを設定されている書式で
  def format_date(time)
    return '' unless time.respond_to?(:strftime)
    if @site.site_setting.nil? || @site.site_setting.date_format.nil?
      time.strftime('%Y/%m/%d')
    else
      time.strftime(@site.site_setting.date_format)
    end
  end

  # 日時をサイトの一般設定(site_setting)で設定されている時間け書式で返す
  # == Example
  # * format_date(Time.now) -> 現在時を設定されている書式で
  # * format_date(@article.updated_at) -> 記事の変更時間を設定されている書式で
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

  # editor の投稿欄の大きさ(行数)を返す.
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
    
    "<link rel='alternate' type='application/#{format}+xml' title='RSS' " +
    " href='#{request.protocol}#{request.host_with_port}" + 
    "#{url_for(:controller => 'articles', :action => 'index', :site => @site.name, :format => format)}' />".
    html_safe
  end

  # rss へのlinkタグを表示
  # option には以下のものを指定可能
  # * :image => アイコン画像へのパス
  # * :text => テキスト, または atlテキスト
  # * :class => tagのclass
  # * :id => tagのid
  # == 例
  # rss_link :image => '/rss.png' :text => 'RSS表示'
  #   => <a href="http://<host>/<site>/articles/index.rss"><img alt="RSS表示" src="/rss.png" /></a>
  # rss_link :text => "RSS表示", :class => "rss_link"
  #   => <a href="http://<host>/<site>/articles/index.atom" class="rss_link">RSS表示</a>
  def rss_link(options = {})
    format = if @site.view_setting && @site.view_setting.rss_type == "atom"
      "atom"
    else
      "rss"
    end

    link_to(
    if options[:image]  
      image_tag(options[:image], 
      :alt => h(if options[:text]  
                options[:text] 
              else 
                'RSS' 
              end) )
    else  
      h(if options[:text]  
        options[:text] 
      else 
        'RSS' 
      end)
    end,
    request.protocol + request.host_with_port + 
    url_for(:controller => 'articles', :action => 'index', :site => @site.name, :format => format),
    :id => if options[:id] then options[:id] else nil end,
    :class => if options[:class] then options[:class] else nil end
    )
  end
  
  #  問い合わせページへのリンク
  # option には以下のものを指定可能
  # * :image => アイコン画像へのパス
  # * :text => テキスト, または atlテキスト
  # * :class => tagのclass
  # * :id => tagのid
  # 例
  # inquiry_link :image => '/inquiry.png' :text => '問い合わせ'
  #   => <a href="http://<host>/<site>/inquiry/index"><img alt="問い合わせ" src="/inquiry.png" /></a>
  # inquiry_link :text => "問い合わせ", :id => 'rss_link'
  #   => <a href="http://<host>/<site>/inquiry/index" id="rss_link">問い合わせ</a>
  def inquiry_link(options = {})
    link_to(
    if options[:image]  
      image_tag(options[:image], 
      :alt => h(if options[:text]  
                options[:text] 
              else 
                'Inquiry' 
              end) )
    else  
      h(if options[:text]  
        options[:text] 
      else 
        'Inquiry' 
      end)
    end,
    request.protocol + request.host_with_port + 
    url_for(:controller => 'inquiry', :action => 'index', :site => @site.name),
    :id => if options[:id] then options[:id] else nil end,
    :class => if options[:class] then options[:class] else nil end
    ) 
  end
  
  # サイト説明を返す
  def site_description
    @site.description || ""
  end
  
  # サイトのコピーライトを返す
  def copyright
    @site.copyright || ""
  end
  
  # サイトタイトルを返す
  def site_title
    @site.title || ""
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
