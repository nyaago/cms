# == Site::TemplateController
# レイアウトベーステンプレート、テーマの選択
class Site::ThemeController < Site::BaseController

  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "theme"].freeze
  
  def index
    @site = current_user.site
    @themes = Layout::Theme.load
    @selected_theme = @themes.find_by_name(@site.site_layout.theme)
    #@site.theme = 'default'
  end
  
  # PUT /theme/1
  # PUT /theme/1.xml
  def update
    @site = Site.find_by_id( current_user.site_id)
    if @site.nil? || @site.site_layout.nil?
      respond_to do |format|
        @themes = Layout::Theme.load
        @selected_theme = @themes.find_by_name(@site.site_layout.theme)
        
        flash[:notice] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
        format.html { 
          render :action => "index" }
        format.xml  { render :xml => @site.errors, 
          :status => :unprocessable_entity }
        return
      end
    end
    # 属性設定
#    @site.user_id = current_user.id
    @site.site_layout.attributes = params[:site_layout]

    respond_to do |format|
      # 変更されていれば、履歴を作成
      if @site.site_layout.save(:validate => true)
        format.html { redirect_to(index_url, 
          :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))}
        format.xml  { head :ok }
      else
        @themes = Layout::Theme.load
        @selected_theme = @themes.find_by_name(@site.site_layout.theme)
        format.html { render :action => "index" }
        format.xml  { render :xml => @site.errors, 
          :status => :unprocessable_entity }
      end
    end
  end

  # 一覧ページへのurlを返す
  def index_url
    url_for(:action => :index, 
      :page => if !params[:page].blank? then params[:page] else 1 end,
      :sort => if !params[:sort].blank? then params[:sort] else nil end,
      :direction => if !params[:direction].blank? then params[:direction] else nil end
      )
  end
  
  
end
