# == SiteAdmin::ThemeController
# レイアウトテーマの選択
class SiteAdmin::ThemeController < SiteAdmin::BaseController

  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site_admin", "theme"].freeze
  
  def index
    @themes = Layout::Theme.load
    @selected_theme = @themes.find_by_name(@site.site_layout.theme)
    #@site.theme = 'default'
  end
  
  # PUT /theme/1
  # PUT /theme/1.xml
  def update
    @site = Site.find_by_id( @site.id)
    if @site.nil? || @site.site_layout.nil?
      respond_to do |format|
        @themes = Layout::Theme.load.sort {|a,b| a.order <=> b.order }
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
    @site.user = current_user

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
    url_for(:action => :index)
  end
  
  
end
