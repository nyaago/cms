# = Site::PagesController
# 記事作成関連のコントローラー
# == 継承先で作成すべきmethod
# * articles 
# * self.model
# * self.translation_scope
class Site::ArticlesController < Site::BaseController

  helper :all

  # 記事一覧の１ページの件数
  PER_PAGR = 3
  
  # 翻訳リソースのスコープ
  #TRANSLATION_SCOPE = ["messages", "site", "pages"].freeze
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
    @articles = articles.order(order_by).
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
    flash[:notice] = ''
    @article = 
    if params[:is_history]
      article = PageArticleHistory.find_by_id_and_site_id(
        params[:id] ,
        current_user.site_id)
      if !article.nil?
        article.id = article.article_id
      end
      article
    else 
      articles.where("id = :id", :id => params[:id]).first
    end
  end


  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = articles.where("id = :id", :id => params[:id]).first
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
  
  
  
  
end
