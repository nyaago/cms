# = ApplicationController
# 公開ページ共通のController
class ApplicationController < ActionController::Base
  protect_from_forgery # :except => :hoge
  
  NEW_BLOGS_MAX = 5
  
  # action実行前フィルター.siteモデルをロード
  # サイトがなければ, 404リダイレクト
  prepend_before_filter :load_site
  
  before_filter         :new_blogs
  
  before_filter         :blog_months
  
  attr_reader  :site
    
  #def hello
    # self.allow_forgery_protection = false
  #end
  
  protected 
  
  # siteモデルをロード
  # サイトがなければ, 404リダイレクト
  def load_site
    
    site_name = params[:site]
    @site = nil
    if !site_name.blank?
      @site = Site.find_by_name(site_name)
    end
    if @site.nil?
      respond_to do |format|
         format.html { 
           render :file => "#{::Rails.root.to_s}/public/404.html", 
            :status => :not_found 
          }
         format.xml  { render :status => :not_found }
       end
       return
    end
    @site
    
  end
  
  def new_blogs
    @new_blogs = @site.blogs.where("published = true").
                        order("updated_at desc").
                        limit(@site.view_setting.title_count_in_home)

    
    
  end
  
  def blog_months
    @blog_months = BlogArticle.updated_months
  end
  
end
