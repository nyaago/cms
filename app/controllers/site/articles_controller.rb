# = Site::ArticlesController
# 記事作成関連のコントローラー
class Site::ArticlesController < Site::BaseController
  
  PER_PAGR = 3

  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "articles"].freeze
  # ソート可能なカラム一覧
  SORTABLE_COLUMN = ['title', 'updated_at', 'heading_level'].freeze
  # ソートの方向一覧
  ORDER_DIRECTION = ['asc', 'desc'].freeze
  
  # GET /articles
  # GET /articles.xml
  # 記事一覧の表示
  def index
    @articles = Article.paginate(:all, 
                              ["site_id = ?", current_user.site_id],
                              :order => order_by,
                              :page => if !params[:page].blank? && params[:page].to_i >= 1 
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
    @article = Article.find_by_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new
    @headings = Category::HeadingLevel.map_for_selection

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find_by_id(params[:id])
    @headings = Category::HeadingLevel.map_for_selection
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    @article.site_id = current_user.site_id
    @article.article_type = Article::TYPE_PAGE
    respond_to do |format|
      if @article.save
        format.html { redirect_to(index_url, 
          :notice => I18n.t("created", :scope => TRANSLATION_SCOPE)) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        @headings = Category::HeadingLevel.map_for_selection
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(index_url, 
          :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))}
        format.xml  { head :ok }
      else
        @headings = Category::HeadingLevel.map_for_selection
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    respond_to do |format|
      format.html { redirect_to(index_url, 
        :notice => I18n.t("destroyed", :scope => TRANSLATION_SCOPE)) }

      format.xml  { head :ok }
    end
  end  
  
  private 
  
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
      'title' 
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
  
end
