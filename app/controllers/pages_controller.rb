class PagesController < ApplicationController
  
  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = unless params[:page].blank? 
      Article.find_by_name_and_site_id(params[:page], @site.id) 
    else
      Article.find_by_is_home_and_site_id(true, @site.id) 
    end
    @article = Article.find_by_id(params[:id]) if @article.nil? &&  !params[:id].nil?      

    if @article.nil?
      respond_to do |format|
         format.html { 
           render :file => "#{::Rails.root.to_s}/public/404.html", 
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
