# = PagesController
# ページ記事表示のコントローラー
class PagesController < ApplicationController

  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "pages"].freeze
  
  # GET /pages/show/1
  # GET /pages/show/1.xml
  # 記事を表示
  def show
    arel = unless params[:page].blank? 
      @site.pages.where("name = :name", :name => params[:page])
    else
      @site.pages.where("is_home = true and published = true")
    end
    unless current_user 
      arel = arel = arel.where("published = ?", true)
    end                              
    @article = arel.first

    if @article.nil? || 
        current_user && (@article.site != current_user.site && !current_user.is_admin)
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
    @article = if params[:id]
      PageArticle.where("site_id = :site_id", :site_id => @site.id).
                      where("parent_id = :id", :id => params[:id]).
                      order('updated_at desc').
                      first
    else
      @site.articles.where("site_id = :site_id", :site_id => @site.id).
                    where("is_home = true").
                    first
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
  
  # 現在ログインしているユーザセッション情報を得る
  def current_user_session
    @current_user_session ||= UserSession.find
  end
  
  # 現在ログインしているユーザの情報(User)を得る
  # 
  def current_user
    request.session_options[:expire_after] = 1.weeks
    @current_user ||= current_user_session && current_user_session.user
  end
  
end
