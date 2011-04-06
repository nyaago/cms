# = PagesController
# ページ記事表示のコントローラー
class PagesController < ApplicationController

  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "pages"].freeze
  
  # GET /pages/show/1
  # GET /pages/show/1.xml
  # 記事を表示
  def show
    @article = unless params[:page].blank? 
      @site.pages.where("name = :name and published = true", :name => params[:page])
    else
      @site.pages.where("is_home = true and published = true")
    end.
    where("is_temporary <> true or is_temporary is null").
    first
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
  
  # GET /blogs/preview/1
  # 記事プレビュー
  def preview
    flash[:notice] = ''
    @site = Site.find_by_name(params[:site])
    unless can_preview?
      respond_to do |format|
         format.html { 
           render :file => "#{::Rails.root.to_s}/app/views/404.html.erb", 
            :status => :not_found 
          }
         format.xml  { render :status => :not_found }
       end
       return
    end
    @article = @site.articles.where("parent_id = :id", :id => params[:id]).
                        order('updated_at desc').
                        first
    if @article.nil?
      flash[:notice] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
    end
    respond_to do |format|
      format.html do  
        render :action => :show,
              :layout =>  @site.site_layout.theme_layout_path_for_rendering 
      end
      format.xml  { render :xml => @article }
    end
  end
  
  private
  
  # preview の権限があるか?
  def can_preview?
    current_user && 
      (current_user.site && current_user.site.name == @site.name  ||
      current_user.is_admin)
  end
  
  
end
