# = Site::PagesController
# 記事作成関連のコントローラー
# == 継承先で作成すべきmethod
# * articles 
# * self.model
# * self.class.translation_scope
class Site::ArticlesController < Site::BaseController

  helper :all

  # 記事一覧の１ページの件数
  PER_PAGR = 3
  
  # 翻訳リソースのスコープ
  #self.class.translation_scope = ["messages", "site", "pages"].freeze
  # @@translation_scape = nil
  # ソート可能なカラム一覧
  SORTABLE_COLUMN = 
  ['name','title', 'updated_at', 'menu_order', 'published', 'is_home'].freeze
  # ソートの方向一覧
  ORDER_DIRECTION = ['asc', 'desc'].freeze
  
  # GET /articles
  # GET /articles.xml
  # 記事一覧の表示
  def index
    @months = self.class.model.updated_months(@site.id)
    cur_month = if params[:month] then params[:month] else nil end
    @articles = articles.filter_by_updated_month(cur_month).
                        order(order_by).
                        paginate(
                              :page => 
                                if !params[:page].blank? && params[:page].to_i >= 1 
                                  params[:page].to_i
                                else 
                                  1 
                                end, 
                              :per_page => PER_PAGR)

    #p "total -- " + @articles.total_entries.to_s
    if @articles.size == 0
      flash[:notice] = I18n.t("none", :scope => self.class.translation_scope)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end


  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = self.class.model.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = 
    if params[:is_history]
      article = PageArticleHistory.find_by_id_and_site_id(
        params[:id] ,
        @site.id)
      if !article.nil?
        article.id = article.article_id
      end
      article
    else 
      articles.where("id = :id", :id => params[:id]).first
    end
    if @article.nil?
      flash[:notice] = I18n.t("not_found", :scope => self.class.translation_scope)
    end
  end


  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = articles.where("id = :id", :id => params[:id]).first
    if @article.nil?
      respond_to do |format|
        format.html { redirect_to(index_url, 
          :notice => I18n.t("not_found", :scope => self.class.translation_scope)) }
        format.xml  { render :xml => @article.errors, 
          :status => :unprocessable_entity }
      end
    end

    @article.destroy
    respond_to do |format|
      format.html { redirect_to(index_url, 
        :notice => I18n.t("destroyed", :scope => self.class.translation_scope)) }

      format.xml  { head :ok }
    end
  end  
  
  # 一括操作の実行.
  # <操作名>_by_id メソッドで個々のモデル要素の操作を実行していく.
  # == リクエストパラーメーター
  # * [record_parameter_name][:processing_method] => 操作名(destroy..)
  # * [record_parameter_name][:checked][:id] => チェックされた画像モデルのid
  def process_with_batch
    p " ==== parameter -- #{record_parameter_name}"
    p processing = params[record_parameter_name]
    
    # 操作(destroy..)を取得
    processing = params[record_parameter_name][:processing_method]
    # 処理を行うmethod('<操作>_by_id')の有無をチェック
    if !respond_to?(processing + '_by_id', true)
      return redirect_to(url_for(:action => :index), 
      :notice => I18n.t("not_implemented_batch", :scope => self.class.translation_scope)) 
    end
    if params[record_parameter_name][:checked].empty? 
      return redirect_to(url_for(:action => :index)) 
    end
    # checkされた　行ごとの処理
    params[record_parameter_name][:checked].each do |attr|
      send(processing + '_by_id', attr[1].to_i)
    end
    #
    redirect_to(url_for(:action => :index), 
    :notice => I18n.t("complete_#{processing}_batch", 
      :scope => self.class.translation_scope,
      :count => params[record_parameter_name][:checked].size.to_s)) 
  end
  
  
  
  protected 
  
  
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
  
  # リクエストパラメータに含まれるレコードのパラメーター名
  def record_parameter_name
    self.class.model.name.underscore.match(/^([a-z\-]+)_([a-z]+)$/)[1].pluralize.to_sym
  end
  
  # 指定されたidの行を削除
  def destroy_by_id(id)
    Article.delete(id)
  end
  
  
  
end
