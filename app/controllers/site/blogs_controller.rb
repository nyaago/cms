# = Site::BlogsController
# 記事作成関連のコントローラー
class Site::BlogsController < Site::ArticlesController

  helper :all

  # 記事履歴の表示件数制限
  LIMIT_HISTORY = 20

  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "blogs"].freeze

  # GET /pages/1
  # GET /pages/1.xml
  # 記事詳細表示
  def show
    flash[:notice] = ''
    @article = articles.where("id = :id", :id => params[:id]).first
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end


  # POST /articles
  # POST /articles.xml
  def create
    @article = self.class.model.new(params[:blog_article])
    @article.site_id = current_user.site_id
    @article.user_id = current_user.id

    # 公開開始日
    @article.published_from = date_from_partial(params[:published_from])

    respond_to do |format|
      if @article.save(:validate => true)
        format.html { redirect_to(index_url, 
          :notice => I18n.t("created", :scope => TRANSLATION_SCOPE)) }
        format.xml  { render :xml => @article, :status => :created, 
          :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, 
          :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find_by_id_and_site_id(params[:id], current_user.site_id)
    if @article.nil?
      respond_to do |format|
        flash[:notice] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
        format.html { 
          render :action => "edit" }
        format.xml  { render :xml => @article.errors, 
          :status => :unprocessable_entity }
      end
    end
    # 属性設定
    @article.user_id = current_user.id
    @article.attributes = params[:blog_article]
    # 公開開始日
    @article.published_from = date_from_partial(params[:published_from])
    respond_to do |format|
      if @article.save(:validate => true)
        format.html do 
          flash[:notice] = I18n.t("updated", :scope => TRANSLATION_SCOPE)
          redirect_to(index_url,
          :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, 
          :status => :unprocessable_entity }
      end
    end
  end


  protected

  # ### ArticlesController 抽象メソッドの実装

  # 記事タイプ

  # 記事一覧を得る
  def articles
    @site.blogs   
  end

  # モデルクラス
  def self.model
    BlogArticle
  end

  # 翻訳リソースのscope
  def self.translation_scope
    TRANSLATION_SCOPE
  end

  # ### ArticlesController 抽象メソッドの実装 終わり

  # order by のカラムを返す.
  # リクエストパラメーターの'sort'で指定されているもの、あるいはデフォルトのカラム名を返す.
  def order_column()
    if !params[:sort].blank?  && SORTABLE_COLUMN.include?(params[:sort])  
      params[:sort] 
    else 
      'updated_at' 
    end
  end
  
  # order by の方向を返す.
  # リクエストパラメーターの'direction'で指定されているもの、あるいはデフォルトで'asc'を返す.
  def order_direction()
    if !params[:direction].blank? && ORDER_DIRECTION.include?(params[:direction]) 
      params[:direction] 
    else 
      'desc' 
    end
  end
  

end
