# = Site::PagesController
# 記事作成関連のコントローラー
class Site::PagesController < Site::BaseController

  helper :all

  # 記事一覧の１ページの件数
  PER_PAGR = 3
  # 記事履歴の表示件数制限
  LIMIT_HISTORY = 20
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "pages"].freeze
  # ソート可能なカラム一覧
  SORTABLE_COLUMN = 
  ['name','title', 'updated_at', 'menu_order', 'published', 'is_home'].freeze
  # ソートの方向一覧
  ORDER_DIRECTION = ['asc', 'desc'].freeze
  
  # GET /articles
  # GET /articles.xml
  # 記事一覧の表示
  def index
    @articles = @site.pages.order(order_by).
                        paginate(
                              :page => 
                                if !params[:page].blank? && params[:page].to_i >= 1 
                                  params[:page].to_i
                                else 
                                  1 
                                end, 
                              :per_page => PER_PAGR)

    #p "total -- " + @articles.total_entries.to_s
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  # 記事詳細表示
  def show
    flash[:notice] = ''
    @article = Article.find_by_id_and_site_id(params[:id], current_user.site_id)
    @article_histories = if @article
      ArticleHistory.where("article_id = ?", params[:id]).
                          order('created_at desc').
                          limit(LIMIT_HISTORY)
    else
      nil
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
    @article = @site.pages.where("id = :id", params[:id])
    @article = Article.find_by_id_and_site_id(params[:id], current_user.site_id)
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
    @article = Article.find_by_id_and_site_id(params[:id], current_user.site_id)
    if @article.nil?
      @articles = Article.where("site_id = :site_id", 
                                :site_id => current_user.site_id).
                                order('menu_order')
      render :action => :table_for_placing
      return
    end
    @article.to_next_menu_order 
    @articles = Article.where("site_id = :site_id", 
                              :site_id => current_user.site_id).
                              order('menu_order')
    respond_to do |format|
      format.html do
        render :action => :table_for_placing, :layout => nil
      end
    end
  end


  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    flash[:notice] = ''
    @article = 
    if params[:is_history]
      article = ArticleHistory.find_by_id_and_site_id(
        params[:id] ,
        current_user.site_id)
      if !article.nil?
        article.id = article.article_id
      end
      article
    else 
      Article.find_by_id_and_site_id(
        params[:id] ,
        current_user.site_id)
    end
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    @article.site_id = current_user.site_id
    @article.user_id = current_user.id
    @article.article_type = Article::TYPE_PAGE
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
    # 変更前の状態をバックアップ
    article_before_update = @article.clone
    article_before_update.id = @article.id
    # 属性設定
    @article.user_id = current_user.id
    @article.attributes = params[:article]
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

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find_by_id_and_site_id(params[:id], current_user.site_id)
    if @article.nil?
      respond_to do |format|
        format.html { redirect_to(index_url, 
          :notice => I18n.t("not_found", :scope => TRANSLATION_SCOPE)) }
        format.xml  { render :xml => @article.errors, 
          :status => :unprocessable_entity }
      end
    end

    @article.destroy
    respond_to do |format|
      format.html { redirect_to(index_url, 
        :notice => I18n.t("destroyed", :scope => TRANSLATION_SCOPE)) }

      format.xml  { head :ok }
    end
  end  
  
  private 
  
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
    ArticleHistory.create(history)
  end
  
  # 一覧ページへのurlを返す
  def index_url
    url_for(:action => :index, 
      :page => if !params[:page].blank? then params[:page] else 1 end,
      :sort => if !params[:sort].blank? then params[:sort] else nil end,
      :direction => if !params[:direction].blank? then params[:direction] else nil end
      )
  end
  
  # order by 句を返す
  # リクエストパラメーターの'sort','direction'を参照,またはデフォルト値より.
  def order_by
    order_column + ' ' + order_direction
  end
  
  # order by のカラムを返す.
  # リクエストパラメーターの'sort'で指定されているもの、あるいはデフォルトのカラム名を返す.
  def order_column()
    if !params[:sort].blank?  && SORTABLE_COLUMN.include?(params[:sort])  
      params[:sort] 
    else 
      'name' 
    end
  end

  # order by の方向を返す.
  # リクエストパラメーターの'direction'で指定されているもの、あるいはデフォルトで'asc'を返す.
  def order_direction()
    if !params[:direction].blank? && ORDER_DIRECTION.include?(params[:direction]) 
      params[:direction] 
    else 
      'asc' 
    end
  end
  
  def date_from_partial(date_params)
    
    begin
      require 'time'
      if date_params.include?(:date) && !date_params[:date].blank?  && 
          date_params.include?(:hour) && date_params.include?(:minute)  
        Time.parse("#{date_params[:date]} #{date_params[:hour]}:#{date_params[:minute]}:0")
      elsif date_params.include?(:date) && !date_params[:date].blank?
        Time.parse("#{date_params[:date]}")
      else
        nil
      end
    rescue 
      require 'parsedate'
      if date_params.include?(:date) && !date_params[:date].blank?  && 
          date_params.include?(:hour) && date_params.include?(:minute)  
        ParseDate::parsedate("#{date_params[:date]} #{date_params[:hour]}:#{date_params[:minute]}:0")
        Time::local(*ary[0..-3])
      elsif date_params.include?(:date) && !date_params[:date].blank?
        ParseDate::parsedate("#{date_params[:date]}")
        Time::local(*ary[0..-3])
      else
        nil
      end
    end
  end
  
end
