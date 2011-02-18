class Site::OptimizationController < Site::BaseController
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "optimization"].freeze
  
  # indexページ
  # 各一般設定を行うページを表示
  def index
    @optimization = @site.search_engine_optimization
  end
  
  # setting/update/1
  # setting/update/1.xml
  # 一般設定フォームの内容でsite/site_setting モデル更新.
  def update
    @optimization = @site.search_engine_optimization
    if @optimization.nil?
      # site not found
      respond_to do |format|

        flash[:notice] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
        format.html { 
          render :action => "index" }
        format.xml  { render :xml => @optimization.errors, 
          :status => :unprocessable_entity }
        return
      end
    end
    # 属性設定
#    @site.user_id = current_user.id
    @optimization.attributes = params[:search_engine_optimization]
    respond_to do |format|
      # 画像登録 + site_layoutモデルの登録
      if @optimization.save(:validate => true) 
        format.html { redirect_to(index_url, 
          :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))}
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @optimization .errors, 
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
