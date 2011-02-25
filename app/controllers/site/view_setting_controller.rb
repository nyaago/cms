# = Site::ViewSettingController
# 表示設定
class Site::ViewSettingController < Site::BaseController

    # 翻訳リソースのスコープ
    TRANSLATION_SCOPE = ["messages", "site", "view_setting"].freeze

    # indexページ
    # 表示設定を行うページを表示
    def index
      @view_setting = @site.view_setting
    end

    # view_setting/update/1
    # view_setting/update/1.xml
    # 表示設定フォームの内容でsite/view_setting モデル更新.
    def update
      @view_setting = @site.view_setting
      if @view_setting.nil?
        # site not found
        respond_to do |format|

          flash[:notice] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
          format.html { 
            render :action => "index" }
          format.xml  { render :xml => @view_setting.errors, 
            :status => :unprocessable_entity }
          return
        end
      end
      # 属性設定
  #    @site.user_id = current_user.id
      @view_setting.attributes = params[:view_setting]
      respond_to do |format|
        # view_settingモデルの登録
        if @view_setting.save(:validate => true) 
          format.html { redirect_to(index_url, 
            :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))}
          format.xml  { head :ok }
        else
          format.html { render :action => "index" }
          format.xml  { render :xml => @view_setting .errors, 
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
