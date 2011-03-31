class Admin::SitesController < Admin::BaseController

  # 記事一覧の１ページの件数
  PER_PAGR = 3
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "admin", "sites"].freeze

  
  # ソート可能なカラム一覧
  SORTABLE_COLUMN = 
  ['name','title','published', 'suspended', 'canceled', 'email', 'created_at', 'updated_at'].freeze
  # ソートの方向一覧
  ORDER_DIRECTION = ['asc', 'desc'].freeze
  
  # Site一覧を表示
  # GET admin/site/index
  # リクエストパラメータとして以下を受ける
  # * page => ページ
  # * sort => ソートカラム名
  # * direction => ソートの方向(asc | desc)
  def index
    @sites = Site.select('id,name,title,published,suspended,canceled,email,created_at,updated_at').
                            order(order_by).
                            paginate(
                                  :page => 
                                    if !params[:page].blank? && params[:page].to_i >= 1 
                                      params[:page].to_i
                                    else 
                                      1 
                                    end, 
                                  :per_page => PER_PAGR)
    # 最終ページより後になっている場合は、1ページ目へ
    if @sites.size == 0 && params[:page].to_i > 1 then  
      params[:page] =  1
      return self.index
    end
    
    if @sites.size == 0
      flash[:notice] = I18n.t :none, :scope => TRANSLATION_SCOPE
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sites }
    end
    
  end

  # Site編集ページの表示
  # GET admin/site/edit/<id>
  # リクエストパラーメータとして Site の id を受ける
  def edit
    flash[:notice] = ''
    @site = Site.find_by_id(params[:id])
    @user = User.new
    if @site.nil?
      flash[:notice] = I18n.t :not_found, :scope => TRANSLATION_SCOPE
    end
    respond_to do |format|
      format.html { render :action => :edit }
      format.xml { render :xml => @site }
    end
  end
  
  # Siteの変更
  # PUT admin/site/update
  def update
    @site = Site.find_by_id(params[:id])
    if @site.nil?
      flash[:notice] = I18n.t :not_found, :scope => TRANSLATION_SCOPE
      respond_to do |format|
        format.html { render :action => :edit}
        format.xml { render :xml => :NG }
      end
      return
    end
    if @site.update_attributes(params[:site])
      respond_to do |format|
        format.html do 
          redirect_to(index_url)
        end
        format.xml { render :xml => :ok }
      end
    else
      @user = User.new
      respond_to do |format|
        format.html { render :action => :edit}
        format.xml { render :xml => :NG }
      end
    end
  end
  
  # Siteの削除
  # PUT admin/site/destroy/<id>
  def destroy
    @site = Site.find_by_id(params[:id])
    if @site.nil?
      flash[:notice] = I18n.t :not_found, :scope => TRANSLATION_SCOPE
      respond_to do |format|
        format.html do 
          redirect_to(index_url)
        end
        format.xml { render :xml => :NG }
      end
      return
    end
    @site.destroy
    respond_to do |format|
      flash[:notice] = I18n.t :destroyed, :scope => TRANSLATION_SCOPE
      format.html do 
        redirect_to(index_url)
      end
      format.xml { render :xml => :ok }
    end
    
  end 
  
  # Siteの新規編集
  # GET /admin/site/new
  def new
    @site = Site.new
    @user = User.new
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sites }
    end
  end
    
  # Site の新規登録
  # PUT /admin/site/create
  def create
    @site = Site.new(params[:site])
    @user = User.new(params[:user])
    @user.is_site_admin = true
    begin
      @site.save!(:validate => true)
      @user.site = @site
      @user.save!(:validate => true)
      respond_to do |format|
        format.html do 
          redirect_to(index_url)
        end
        format.xml { render :xml => :ok }
      end
    rescue
      respond_to do |format|
        format.html { render :action => :new }
        format.xml { render :xml => :NG }
      end
    end
  end
  
protected

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

  # 一覧ページへのurlを返す
  def index_url
    url_for(:action => :index, 
      :page => if !params[:page].blank? then params[:page] else 1 end,
      :sort => if !params[:sort].blank? then params[:sort] else nil end,
      :direction => if !params[:direction].blank? then params[:direction] else nil end
      )
  end

  
end
