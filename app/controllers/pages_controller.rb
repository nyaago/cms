class PagesController < ApplicationController
  
  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find_by_name(params[:page]) unless params[:page].nil?
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
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end
  
end
