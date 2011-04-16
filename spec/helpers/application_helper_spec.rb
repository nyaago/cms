# *-* coding: utf-8 *-*
require 'spec_helper'

SITE_ID = 1

describe ApplicationHelper do

  before  do 

    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first

    PageArticle.destroy_all('site_id' => @site.id)
    BlogArticle.destroy_all('site_id' => @site.id)
    
    @pagea = PageArticle.make(:name => 'pagea', :title => 'ホーム', :is_home => true, :site_id => @site.id)
    @pageb = PageArticle.make(:name => 'pageb', :title => '概要', :site_id => @site.id)
    @pagec = PageArticle.make(:name => 'pagec', :title => '商品', :site_id => @site.id)
    @paged = PageArticle.make(:name => 'paged', :title => '実績', :site_id => @site.id)

    @bloga = BlogArticle.make(:title => '記事1')
    @blogb = BlogArticle.make(:title => '記事2')
    @blogc = BlogArticle.make(:title => '記事3')
    @blogd = BlogArticle.make(:title => '記事4')
    
  end
  
  it "eye catch required in header, if eye_catch_type is header_area  " do
    site_layout = @site.site_layout
    site_layout.eye_catch_type  = 'header_area'
    site_layout.save!(:validate => true)
    eye_catch_required?(:header).should == true
  end
  
  it "eye catch required in header, if eye_catch_type is header_area_banner  " do
    site_layout = @site.site_layout
    site_layout.eye_catch_type  = 'header_area_banner'
    site_layout.save!(:validate => true)
    eye_catch_required?(:header).should == true
  end
  
  it "eye catch required in container, if eye_catch_type is content_area  " do
    site_layout = @site.site_layout
    site_layout.eye_catch_type  = 'content_area'
    site_layout.save!(:validate => true)
    eye_catch_required?(:container).should == true
  end
  
  it "eye catch required in content, if eye_catch_type is main_area  " do
    site_layout = @site.site_layout
    site_layout.eye_catch_type  = 'main_area'
    site_layout.save!(:validate => true)
    eye_catch_required?(:contents).should == true
  end
  
  it "eye catch not required, if eye_catch_type is none  " do
    site_layout = @site.site_layout
    site_layout.eye_catch_type  = 'none'
    site_layout.save!(:validate => true)
    eye_catch_required?(:header).should_not == true
    eye_catch_required?(:container).should_not == true
    eye_catch_required?(:contents).should_not == true
  end
  
  it "deault theme_partial_exist?" do
    site_layout = @site.site_layout
    site_layout.theme  = 'default'
    site_layout.save!(:validate => true)
    theme_partial_exist?(:header).should == true
    theme_partial_exist?(:side).should == true
    theme_partial_exist?(:footer).should == true
  end

  it "unknown theme partial not exist?" do
    site_layout = @site.site_layout
    site_layout.theme  = 'unknown'
    site_layout.save!(:validate => true)
    theme_partial_exist?(:header).should == true
    theme_partial_exist?(:side).should == true
    theme_partial_exist?(:footer).should == true
    site_layout.theme  = 'default'
    site_layout.save!(:validate => true)
  end
  
  it "header image tag" do
    site_layout = @site.site_layout
    image = LayoutImage.create(:image => uploaded_file('header.jpg', 'image/jpg'))
    site_layout.header_image_url = image.url
    site_layout.save!(:validate => true)
    exp = Regexp.new("^<img.+src=\"/layout\-images\/#{image.id}\/header.jpg?.+\/>$")
    header_image_tag.should match(exp)
    exp = Regexp.new("^<img.+alt=\"#{@site.title}\".*\/>$")
    header_image_tag.should match(exp)
  end
  
  it "footer image tag" do
    site_layout = @site.site_layout
    image = LayoutImage.create(:image => uploaded_file('footer.jpg', 'image/jpg'))
    site_layout.footer_image_url = image.url
    site_layout.save!(:validate => true)
    exp = Regexp.new("^<img.+src=\"/layout\-images\/#{image.id}\/footer.jpg?.+\/>$")
    footer_image_tag.should match(exp)
    exp = Regexp.new("^<img.+alt=\"#{@site.title}\".*\/>$")
    footer_image_tag.should match(exp)
  end
  
  it "logo image tag (no home link)" do
    site_layout = @site.site_layout
    image = LayoutImage.create(:image => uploaded_file('logo.jpg', 'image/jpg'))
    site_layout.logo_image_url = image.url
    site_layout.global_navigation = 'no_home_link'
    site_layout.save!(:validate => true)
    exp = Regexp.new("^<img.+src=\"/layout\-images\/#{image.id}\/logo.jpg?.+\/>$")
    logo_image_tag.should match(exp)
    exp = Regexp.new("^<img.+alt=\"#{@site.title}\".*\/>$")
    logo_image_tag.should match(exp)
  end

  it "logo image tag (home link)" do
    site_layout = @site.site_layout
    image = LayoutImage.create(:image => uploaded_file('logo.jpg', 'image/jpg'))
    site_layout.logo_image_url = image.url
    site_layout.global_navigation = 'home_link'
    site_layout.save!(:validate => true)
    exp = Regexp.new("^<a href=\"/#{@site.name}\".+<img.+src=\"/layout\-images\/#{image.id}\/logo.jpg?.+")
    logo_image_tag.should match(exp)
    exp = Regexp.new("<img.+alt=\"#{@site.title}\".*\/>")
    logo_image_tag.should match(exp)
  end
  
  it "home link required?" do
    site_layout = @site.site_layout
    site_layout.global_navigation = 'home_link'
    site_layout.save!(:validate => true)
    home_link_required?.should == true
  end
  
  it "home link not required?" do
    site_layout = @site.site_layout
    site_layout.global_navigation = 'no_home_link'
    site_layout.save!(:validate => true)
    home_link_required?.should == false
  end
  
  it "background css " do
    site_layout = @site.site_layout
    image = LayoutImage.create(:image => uploaded_file('background.jpg', 'image/jpg'))
    site_layout.background_image_url = image.url
    site_layout.background_repeat = "repeat"
    site_layout.save!(:validate => true)
    
    exp = Regexp.new("background-repeat:.+repeat")
    background_css.should match(exp)

    exp = Regexp.new("background-image:.*url.+/layout\-images\/#{image.id}\/background\.jpg")

    background_css.should match(exp)


  end
  
  it "menu html" do
    html = menu_html(:class => :menu_class, :id => :menu_id)
    exp = Regexp.new("^<ul.+class=[\"\']{1}menu_class[\"\']{1}")
    html.should match(exp)
    exp = Regexp.new("^<ul.+id=[\"\']{1}menu_id[\"\']{1}")
    html.should match(exp)
    exp = Regexp.new("<li.+id=[\"\']{1}menu_id_#{@pagea.name}[\"\']{1}><a href=[\"\']{1}/#{@site.name}")
    html.should match(exp)
    exp = Regexp.new("<li.+id=[\"\']{1}menu_id_#{@pageb.name}[\"\']{1}><a href=[\"\']{1}/#{@site.name}/pages/pageb")
    html.should match(exp)
    exp = Regexp.new("<li.+id=[\"\']{1}menu_id_#{@pagec.name}[\"\']{1}><a href=[\"\']{1}/#{@site.name}/pages/pagec")
    html.should match(exp)
  end
  
  it "title tag of pages" do
    def params
      {:controller => 'pages'}
    end
    seo = @site.search_engine_optimization
    seo.page_title_format = "%page_title% --- %site_title%"
    seo.save!(:validate => false)
    @article = @pagea
    title_tag.should == "<title>#{@article.title} --- #{@site.title}</title>"
    
  end

  it "title tag of blogs" do
    def params
      {:controller => 'blogs'}
    end
    seo = @site.search_engine_optimization
    seo.blog_title_format = "%page_title% --- %site_title%"
    seo.save!(:validate => false)
    @article = @bloga
    title_tag.should == "<title>#{@article.title} --- #{@site.title}</title>"
    
  end

  it "title tag of blog months" do
    def params
      {:controller => 'blogs'}
    end
    seo = @site.search_engine_optimization
    seo.blog_title_format = "%page_title% --- %site_title%"
    seo.save!(:validate => false)
    @month = Time.now
    def @month.title
      self.strftime('%Y%m')
    end
    title_tag.should == "<title>#{@month.title} --- #{@site.title}</title>"
    
  end



  it "title tag of inquiry" do
    def params
      {:controller => 'inquiry'}
    end
    @article = nil
    seo = @site.search_engine_optimization
    seo.page_title_format = "%page_title% --- %site_title%"
    seo.save!(:validate => false)
    title_tag.should == 
        "<title>#{I18n.t(:title, :scope => [:messages, :inquiry])} --- #{@site.title}</title>"
    
  end

  
  it "title tag of site/pages" do
    def params
      {:controller => 'site/pages'}
    end
    @article = @blog
    seo = @site.search_engine_optimization
    seo.page_title_format = "%page_title% --- %site_title%"
    seo.save!(:validate => false)
    @article = @pagea
    title_tag.should == "<title>#{@article.title} --- #{@site.title}</title>"
    
  end
  
  it "title tag of site/setting" do
    def params
      {:controller => 'site/setting'}
    end
    @article = nil
    title_tag.should == 
        "<title>#{I18n.t(:title, :scope => [:messages, :site, :setting])} | #{@site.title}</title>"
    
  end

  it "title tag of site/post_setting" do
    def params
      {:controller => 'site/post_setting'}
    end
    @article = nil
    title_tag.should == 
        "<title>#{I18n.t(:title, :scope => [:messages, :site, :post_setting])} | #{@site.title}</title>"
    
  end
  
  
  it "title tag of admin/sites" do
    def params
      {:controller => 'admin/sites'}
    end
    @article = @pagea
    site = @site
    @site = nil
    title_tag.should == 
        "<title>#{I18n.t(:title, :scope => [:messages, :admin])} | #{I18n.t(:title, :scope => [:messages, :admin, :sites])}</title>"
    @site = site
  end
  
  it "meta keywords tag (setting and page)" do
    def params
      {:controller => 'pages'}
    end
    @article = @pagea
    seo = @site.search_engine_optimization
    seo.page_keywords = "ねこ,ぱんだ"
    seo.save!(:validate => false)
    @article.meta_keywords = "ばく,いぬ"
    @article.ignore_meta = false
    @article.save!(:validate => false)
    meta_keywords_tag.should == ("<meta name=\"keywords\" content=\"" + 
                  seo.page_keywords + ',' + @article.meta_keywords +  '"/>')
  end

  it "meta keywords tag (page)" do
    def params
      {:controller => 'pages'}
    end
    @article = @pagea
    seo = @site.search_engine_optimization
    seo.page_keywords = "ねこ,ぱんだ"
    seo.save!(:validate => false)
    @article.meta_keywords = "ばく,いぬ"
    @article.ignore_meta = true
    @article.save!(:validate => false)
    meta_keywords_tag.should == ("<meta name=\"keywords\" content=\"" + 
                    @article.meta_keywords +  '"/>')
  
  end

  it "meta keywords tag (setting and blog)" do
    def params
      {:controller => 'blogs'}
    end
    @article = @bloga
    seo = @site.search_engine_optimization
    seo.blog_keywords = "ねこ,ぱんだ"
    seo.save!(:validate => false)
    @article.meta_keywords = "ばく,いぬ"
    @article.ignore_meta = false
    @article.save!(:validate => false)
    meta_keywords_tag.should == ("<meta name=\"keywords\" content=\"" + 
                    seo.blog_keywords + ',' + @article.meta_keywords +  '"/>')
  end

  it "meta keywords tag (blog)" do
    def params
      {:controller => 'blogs'}
    end
    @article = @bloga
    seo = @site.search_engine_optimization
    seo.blog_keywords = "ねこ,ぱんだ"
    seo.save!(:validate => false)
    @article.meta_keywords = "ばく,いぬ"
    @article.ignore_meta = true
    @article.save!(:validate => false)
    meta_keywords_tag.should == ("<meta name=\"keywords\" content=\"" + 
                    @article.meta_keywords +  '"/>')
  
  end

  it "meta keywords tag (inquiry)" do
    def params
      {:controller => 'inquiry'}
    end
    seo = @site.search_engine_optimization
    seo.page_keywords = "ねこ,ぱんだ"
    seo.save!(:validate => false)
    meta_keywords_tag.should == ("<meta name=\"keywords\" content=\"" + 
                  seo.page_keywords +  '"/>')
  
  end

  it "meta description tag (setting and page)" do
    def params
      {:controller => 'pages'}
    end
    @article = @pagea
    seo = @site.search_engine_optimization
    seo.page_description = "ねこ,ぱんだ"
    seo.save!(:validate => false)
    @article.meta_description = "ばく,いぬ"
    @article.ignore_meta = false
    @article.save!(:validate => false)
    meta_description_tag.should == ("<meta name=\"description\" content=\"" + 
                seo.page_description + ',' + @article.meta_description +  '"/>')
  end

  it "meta description tag (page)" do
    def params
      {:controller => 'pages'}
    end
    @article = @pagea
    seo = @site.search_engine_optimization
    seo.page_description = "ねこ,ぱんだ"
    seo.save!(:validate => false)
    @article.meta_description = "ばく,いぬ"
    @article.ignore_meta = true
    @article.save!(:validate => false)
    meta_description_tag.should == ("<meta name=\"description\" content=\"" + 
                    @article.meta_description +  '"/>')

  end

  it "meta description tag (setting and blog)" do
    def params
      {:controller => 'blogs'}
    end
    @article = @bloga
    seo = @site.search_engine_optimization
    seo.blog_description = "ねこ,ぱんだ"
    seo.save!(:validate => false)
    @article.meta_description = "ばく,いぬ"
    @article.ignore_meta = false
    @article.save!(:validate => false)
    meta_description_tag.should == ("<meta name=\"description\" content=\"" + 
                    seo.blog_description + ',' + @article.meta_description +  '"/>')
  end

  it "meta description tag (blog)" do
    def params
      {:controller => 'blogs'}
    end
    @article = @bloga
    seo = @site.search_engine_optimization
    seo.blog_description = "ねこ,ぱんだ"
    seo.save!(:validate => false)
    @article.meta_description = "ばく,いぬ"
    @article.ignore_meta = true
    @article.save!(:validate => false)
    meta_description_tag.should == ("<meta name=\"description\" content=\"" + 
                      @article.meta_description +  '"/>')

  end

  it "meta description tag (inquiry)" do
    def params
      {:controller => 'inquiry'}
    end
    seo = @site.search_engine_optimization
    seo.page_description = "ねこ,ぱんだ"
    seo.save!(:validate => false)
    meta_description_tag.should == ("<meta name=\"description\" content=\"" + 
                      seo.page_description +  '"/>')

  end

  it "rss2 link for addressbar" do
    def request
      obj = Object.new
      def obj.protocol
        'http://'
      end
      def obj.host_with_port
        'localhost'
      end
      obj
    end
    view_setting = @site.view_setting
    view_setting.rss_type = "rss2"
    view_setting.save!(:validate => true)
    
    exp = Regexp.new("<link rel='alternate'\s+type='application/rss.+xml'\s+title='RSS'\s+" + 
    "href='#{request.protocol}#{request.host_with_port}" +
    "/#{@site.name}/articles/index.rss'")
    
    rss_link_for_addressbar.should match(exp)
  end
  
  it "atom link for addressbar" do
    def request
      obj = Object.new
      def obj.protocol
        'http://'
      end
      def obj.host_with_port
        'localhost'
      end
      obj
    end
    view_setting = @site.view_setting
    view_setting.rss_type = "atom"
    view_setting.save!(:validate => true)
    
    exp = Regexp.new("<link rel='alternate'\s+type='application/atom.+xml'\s+title='RSS'\s+" +
    "href='#{request.protocol}#{request.host_with_port}" +
    "/#{@site.name}/articles/index.atom'")
    
    rss_link_for_addressbar.should match(exp)
  end
  
  it "rss link" do
    def request
      obj = Object.new
      def obj.protocol
        'http://'
      end
      def obj.host_with_port
        'localhost'
      end
      obj
    end
    view_setting = @site.view_setting
    view_setting.rss_type = "rss2"
    view_setting.save!(:validate => true)
    exp = Regexp.new("<a.+href=['\"]{1}#{request.protocol}#{request.host_with_port}/#{@site.name}/articles/index.rss['\"]{1}")
    rss_link.should match(exp)
  end

  it "rss link with text" do
    def request
      obj = Object.new
      def obj.protocol
        'http://'
      end
      def obj.host_with_port
        'localhost'
      end
      obj
    end
    view_setting = @site.view_setting
    view_setting.rss_type = "rss2"
    view_setting.save!(:validate => true)
    exp = Regexp.new("<a.+href=['\"]{1}#{request.protocol}#{request.host_with_port}/#{@site.name}/articles/index.rss['\"]{1}>テキスト<\/a>")
    rss_link(:text => 'テキスト').should match(exp)
  end


  it "atom link" do
    def request
      obj = Object.new
      def obj.protocol
        'http://'
      end
      def obj.host_with_port
        'localhost'
      end
      obj
    end
    view_setting = @site.view_setting
    view_setting.rss_type = "atom"
    view_setting.save!(:validate => true)
    exp = Regexp.new("<a.+href=['\"]{1}#{request.protocol}#{request.host_with_port}/#{@site.name}/articles/index.atom['\"]{1}")
    rss_link.should match(exp)
  end
  
  it "rss link with image" do
    def request
      obj = Object.new
      def obj.protocol
        'http://'
      end
      def obj.host_with_port
        'localhost'
      end
      obj
    end
    view_setting = @site.view_setting
    view_setting.rss_type = "rss2"
    view_setting.save!(:validate => true)
    exp = Regexp.new("<a.+href=['\"]{1}#{request.protocol}#{request.host_with_port}/#{@site.name}/articles/index.rss['\"]{1}.*>" +
        "<img alt=['\"]{1}テキスト['\"]{1}\s+src=['\"]{1}\/hoge.png['\"]{1}.+\/>")
    rss_link(:image => '/hoge.png', :text => 'テキスト').should match(exp)
  end

  
  it "inquiry link" do
    def request
      obj = Object.new
      def obj.protocol
        'http://'
      end
      def obj.host_with_port
        'localhost'
      end
      obj
    end
    exp = Regexp.new("<a.+href=['\"]{1}#{request.protocol}#{request.host_with_port}/#{@site.name}/inquiry['\"]{1}")
    inquiry_link.should match(exp)
    
  end

  it "inquiry link with text" do
    def request
      obj = Object.new
      def obj.protocol
        'http://'
      end
      def obj.host_with_port
        'localhost'
      end
      obj
    end
    exp = Regexp.new("<a.+href=['\"]{1}#{request.protocol}#{request.host_with_port}/#{@site.name}/inquiry['\"]{1}>問い合わせ<\/a>")
    inquiry_link(:text=> '問い合わせ').should match(exp)
    
  end

  it "inquiry link with image" do
    def request
      obj = Object.new
      def obj.protocol
        'http://'
      end
      def obj.host_with_port
        'localhost'
      end
      obj
    end
    exp = Regexp.new("<a.+href=['\"]{1}#{request.protocol}#{request.host_with_port}/#{@site.name}/inquiry['\"]{1}.*>" +
    "<img alt=['\"]{1}問い合わせ['\"]{1}\s+src=['\"]{1}\/hoge.png['\"]{1}.+\/>")
    inquiry_link(:image => '/hoge.png', :text => '問い合わせ').should match(exp)
    
  end

  
end
