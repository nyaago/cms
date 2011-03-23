# = Site::SettingController
# サイト一般設定のcontroller
class Site::SettingController < Site::BaseController
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "setting"].freeze
  
  # indexページ
  # 各一般設定を行うページを表示
  def index
    @site_setting = @site.site_setting
    @site_base = @site
  end
  
  # setting/update/1
  # setting/update/1.xml
  # 一般設定フォームの内容でsite/site_setting モデル更新.
  def update
    site_setting = @site.site_setting    
    if @site.nil? || @site.site_setting.nil?
      # site not found
      respond_to do |format|

        flash[:notice] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
        format.html { 
          render :action => "index" }
        format.xml  { render :xml => @site.errors, 
          :status => :unprocessable_entity }
        return
      end
    end
    # 属性設定
    site = Site.find_by_id(@site.id)
    site.site_setting.attributes = params[:site_setting]
    site.attributes = params[:site_base]
    site.user = current_user
    site.site_setting.user = current_user
    
    begin
      ActiveRecord::Base.transaction do
        site.site_setting.save!(:validate => true) 
        site.save!(:validate => true)
        respond_to do |format|
          format.html { redirect_to(index_url, 
            :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))}
          format.xml  { head :ok }
        end
      end
    rescue
      respond_to do |format|
        @site = site
        @site_setting = site_setting
        format.html { render :action => "index" }
        format.xml  { render :xml => @site.errors, 
          :status => :unprocessable_entity }
      end
    end
  end

  private 

  # 一覧ページへのurlを返す
  def index_url
    url_for(:action => :index)
  end

  
end
