# *-* coding:utf-8 *-*
require 'spec_helper'

describe SearchEngineOptimization do
  before do
    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first
    
    # 記事
    @p1 = PageArticle.make(:name => 'pagea', :title => "ページ1")
    @p2 = PageArticle.make(:name => 'pageb', :title => "ページ2")
    @p3 = PageArticle.make(:name => 'pagec', :title => "ページ3")
    @p4 = PageArticle.make(:name => 'paged', :title => "ページ4")

    @b1 = BlogArticle.make(:title => "お知らせ1")
    @b2 = BlogArticle.make(:title => "お知らせ2")
    @b3 = BlogArticle.make(:title => "お知らせ3")
    @b4 = BlogArticle.make(:title => "お知らせ4")
    
  end
  
  it "page_title_text" do
    optimization = @site.search_engine_optimization
    optimization.page_title_format = "%page_title% --- %site_title%"
    optimization.page_title_text(@p1, @site).should == "#{@p1.title} --- #{@site.title}"
  end
  
  it "page_title_text 2" do
    optimization = @site.search_engine_optimization
    optimization.page_title_format = "%blog_title% の %article_title%"
    optimization.page_title_text(@p1, @site).should == "#{@site.title} の #{@p1.title}"
  end
  
  
  
  it "blog_title_text" do
    optimization = @site.search_engine_optimization
    optimization.blog_title_format = "%page_title% --- %site_title%"
    optimization.blog_title_text(@b1, @site).should == "#{@b1.title} --- #{@site.title}"
  end
  
  it "not_found_title_text" do
    optimization = @site.search_engine_optimization
    request = 'http://locahost/hoge/'
    def request.request_uri
      self.to_s
    end
    optimization.not_found_title_format = "%request_url% はないです"
    optimization.not_found_title_text(request).should == "#{request} はないです"
  end
  
end
