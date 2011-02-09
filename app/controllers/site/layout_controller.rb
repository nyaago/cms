# == Site::LayoutController
# レイアウトテーマの選択
class Site::LayoutController < Site::BaseController
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "layout"].freeze
  
  # indexページ
  # 各レイアウト設定を行うページを表示
  def index
    @site = current_user.site
    @site_layout = @site.site_layout
    @layout_defs = Layout::DefinitionArrays.new
  end
  
  # layout/update/1
  # layout/update/1.xml
  # レイアウトフォームの内容でlayout モデル更新.
  def update
    @site = Site.find_by_id( current_user.site_id)
    if @site.nil? || @site.site_layout.nil?
      respond_to do |format|
        @site_layout = @site.site_layout
        @layout_defs = Layout::DefinitionArrays.new

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
      # 
      if @site.site_layout.save(:validate => true)
        format.html { redirect_to(index_url, 
          :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))}
        format.xml  { head :ok }
      else
        @site_layout = @site.site_layout
        @layout_defs = Layout::DefinitionArrays.new
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
