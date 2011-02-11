# = ApplicationController
#
class ApplicationController < ActionController::Base
  protect_from_forgery # :except => :hoge
  
  # action実行前フィルター.siteモデルをロード
  # サイトがなければ, 404リダイレクト
  before_filter :load_site
  
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
  
end
