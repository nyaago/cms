# = SiteAdmin::PagesController
# 記事作成関連のコントローラー
class SiteAdmin::PagesController < SiteAdmin::ArticlesController

  helper :all

  # 記事履歴の表示件数制限
  LIMIT_HISTORY = 20
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "pages"].freeze

  # GET /pages/1
  # GET /pages/1.xml
  # 記事詳細表示
  def show
    flash[:notice] = ''
    @article = articles.where("id = :id", :id => params[:id]).first
    @article_histories = if @article
       PageArticleHistory.where("article_id = ?", params[:id]).
                          order('created_at desc').
                          limit(LIMIT_HISTORY)
    else
      nil
    end
    if @article.nil?
      flash[:notice] = I18n.t("not_found", TRANSLATION_SCOPE)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end


  # 並び替えページ表示のアクション
  # 一覧部分は、table_for_placingアクションをAjaxで取得しての表示となる。
  def place
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # 並び替えの一覧部分表示のアクション
  # Ajaxでの使用を目的とする
  def table_for_placing
    @articles = @site.pages.order('menu_order')
    respond_to do |format|
      format.html do
        render :layout => nil
      end
    end
  end

  # 記事のメニュー表示位置を１つ前に移動するアクション
  # Ajaxでの実行となり.モデル更新後,viewの一覧テーブル部分のみをreplaceする
  def previous_order
    @article = PageArticle.find_by_id_and_site_id(params[:id], @site.id)
    if @article.nil?
      @articles = @site.pages.order('menu_order')
      render :action => :table_for_placing
      return
    end
    @article.to_previous_menu_order 
    @articles = @site.pages.order('menu_order')    
    respond_to do |format|
      format.html do
        render :action => :table_for_placing, :layout => nil
      end
    end
  end

  # 記事のメニュー表示位置を１つ後ろに移動するアクション
  # Ajaxでの実行となり.モデル更新後,viewの一覧テーブル部分のみをreplaceする
  def next_order
    flash[:notice] = ''
    @article = PageArticle.find_by_id_and_site_id(params[:id], @site.id)
    if @article.nil?
      @articles = PageArticle.where("site_id = :site_id", 
                                :site_id => @site.id).
                                order('menu_order')
      render :action => :table_for_placing
      return
    end
    @article.to_next_menu_order 
    @articles = @site.pages.order('menu_order')
    respond_to do |format|
      format.html do
        render :action => :table_for_placing, :layout => nil
      end
    end
  end

  # POST /articles
  # POST /articles.xml
  def create
    @layout_defs = Layout::DefinitionArrays.new
    @article = self.class.model.new(params[:page_article])
    @article.site_id =  @site.id
    @article.user = current_user

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
    @article = Article.find_by_id_and_site_id(params[:id], @site.id)
    @layout_defs = Layout::DefinitionArrays.new
    if @article.nil?
      respond_to do |format|
        flash[:notice] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
        format.html { 
          render :action => "edit" }
        format.xml  { render :xml => @article.errors, 
          :status => :unprocessable_entity }
      end
    end
    # 変更前の状態をバックアップ
    article_before_update = @article.clone
    article_before_update.id = @article.id
    # 属性設定
    @article.user = current_user
    @article.attributes = if params[:is_history]
      params[:page_article_history]
    else
      params[:page_article]
    end
    # 公開開始日
    @article.published_from = date_from_partial(params[:published_from])
    respond_to do |format|
      # 変更されていれば、履歴を作成
      if @article.changed? then
        save_history_from(article_before_update)
      end
      if @article.save(:validate => true)
        format.html { redirect_to(index_url, 
          :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))}
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
    @site.pages
  end
  
  # モデルクラス
  def self.model
    PageArticle
  end
  
  # 翻訳リソースのscope
  def self.translation_scope
    TRANSLATION_SCOPE
  end
  
  # ### ArticlesController 抽象メソッドの実装 終わり
  
  
  # 記事の履歴を保存.
  # 保存前後で内容がかわっていなければ、作成しない.
  def save_history_from(article_before_update)
    history = {}
    article_before_update.attributes.each_pair do |key, value|
      if key.to_s != 'created_at' and key.to_s != 'updated_at' 
        history[key] = value
      end
    end
    history['last_updated_at'] = article_before_update.updated_at
    history['article_id'] = article_before_update.id
    history['type'] = 'PageArticle'
    PageArticleHistory.create(history)
  end
  
  protected
  
  # ユーザがこのcontroller の機能を使用可能かどうかを返す.
  # userがnilでなければOKにする.
  def accessible_for?(user)
    !!user
  end
  
  
end
