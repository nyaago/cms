# = PagesController
# ページ記事表示のコントローラー
class PagesController < ApplicationController
  
  # GET /pages/1
  # GET /pages/1.xml
  # 記事を表示
  def show
    @article = unless params[:page].blank? 
      Article.find_by_name_and_site_id(params[:page], @site.id) 
    else
      Article.find_by_is_home_and_site_id(true, @site.id) 
    end
#    @article = Article.find_by_id(params[:id]) if @article.nil? &&  !params[:id].nil?      

    if @article.nil?
      respond_to do |format|
         format.html { 
           render :file => "#{::Rails.root.to_s}/app/views/404.html.erb", 
            :status => :not_found 
          }
         format.xml  { render :status => :not_found }
       end
       return
    end

    respond_to do |format|
      format.html do
        render :layout =>  @site.site_layout.theme_layout_path_for_rendering
      end
      format.xml  { render :xml => @article }
    end
  end
  
end
