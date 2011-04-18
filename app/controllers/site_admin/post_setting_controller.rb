# = SiteAdmin::PostSettingController
# 投稿設定 controller
class SiteAdmin::PostSettingController < SiteAdmin::BaseController
  
    # 翻訳リソースのスコープ
    TRANSLATION_SCOPE = ["messages", "site_admin", "post_setting"].freeze

    # indexページ
    # 投稿設定を行うページを表示
    def index
      @post_setting = @site.post_setting
    end

    # post_setting/update/1
    # post_setting/update/1.xml
    # 表示設定フォームの内容でsite/view_setting モデル更新.
    def update
      @post_setting = @site.post_setting
      if @post_setting.nil?
        # site not found
        respond_to do |format|

          flash[:notice] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
          format.html { 
            render :action => "index" }
          format.xml  { render :xml => @post_setting.errors, 
            :status => :unprocessable_entity }
          return
        end
      end
      # 属性設定
  #    @site.user_id = current_user.id
      @post_setting.attributes = params[:post_setting]
      @post_setting.user = current_user
      respond_to do |format|
        # post_settingモデルの登録
        if @post_setting.save(:validate => true) 
          format.html { redirect_to(index_url, 
            :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))}
          format.xml  { head :ok }
        else
          format.html { render :action => "index" }
          format.xml  { render :xml => @post_setting .errors, 
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
