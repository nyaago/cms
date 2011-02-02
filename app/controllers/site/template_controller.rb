# == Site::TemplateController
# レイアウトベーステンプレート、テーマの選択
class Site::TemplateController < Site::BaseController

  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "template"].freeze
  
  def index
    @site = current_user.site
    @templates = Layout::Template.load
    @themes = Layout::Theme.load
    #@site.template = 'default'
    #@site.theme = 'default'
  end
  
  # PUT /template/1
  # PUT /template/1.xml
  def update
    @site = Site.find_by_id( current_user.site_id)
    if @site.nil?
      respond_to do |format|
        flash[:notice] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
        format.html { 
          render :action => "index" }
        format.xml  { render :xml => @site.errors, 
          :status => :unprocessable_entity }
      end
    end
    # 属性設定
#    @site.user_id = current_user.id
    @site.attributes = params[:site]

    respond_to do |format|
      # 変更されていれば、履歴を作成
      if @site.save(:validate => true)
        format.html { redirect_to(index_url, 
          :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))}
        format.xml  { head :ok }
      else
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
