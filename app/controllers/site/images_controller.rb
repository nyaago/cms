# = Site::ImagesController
# 画像一覧、アップロードページのController
class Site::ImagesController < Site::BaseController

  include Site::ImagesHelper
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "images"].freeze
  
  # 記事一覧の１ページの件数
  PER_PAGR = 8

  # 
  BATCH_PROCESSING_METHODS = ['destroy']
  
  # ソート可能なカラム一覧
  SORTABLE_COLUMN = 
  ['image_file_name','title', 'created_at'].freeze
  # ソートの方向一覧
  ORDER_DIRECTION = ['asc', 'desc'].freeze
  
  # 一覧表示
  # 画像モデルの行コレクションとデータのある月日のコレクションを得る
  # == リクエストパラメータ
  # * page - 現在のページ
  # * sort  - 並び変えカラム, defaultは created_at
  # * direction - ソート方向(asc/desc), defaultは desc
  # * images[month] - 年月(yyyymm 書式)
  def index
    @image = Image.new
    @months = Image.created_months(@site.id)
    cur_month = if params[:month] then params[:month] else nil end
    @images = Image.where("site_id = :site_id ",
                          :site_id => @site.id).
                        filter_by_month(cur_month).
                        order(order_by).
                        paginate(
                          :page => 
                            if !params[:page].blank? && params[:page].to_i >= 1 
                              params[:page].to_i
                            else 
                              1 
                            end, 
                          :per_page => PER_PAGR)
    if @images.size == 0
      flash[:notice] = I18n.t(:none, :scope => TRANSLATION_SCOPE)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @images }
    end
  end

  # 選択用の一覧表示
  # 画像モデルの行コレクションとデータのある月日のコレクションを得る
  # == リクエストパラメータ
  # * page - 現在のページ
  # * sort  - 並び変えカラム, defaultは created_at
  # * direction - ソート方向(asc/desc), defaultは desc
  # * images[month] - 年月(yyyymm 書式)
  def selection_list
    @image = Image.new
    @months = Image.created_months(@site.id)
    cur_month = if params[:month] then params[:month] else nil end
    @images = Image.where("site_id = :site_id ",
                          :site_id => @site.id).
                        filter_by_month(cur_month).
                        order(order_by).
                        paginate(
                          :page => 
                            if !params[:page].blank? && params[:page].to_i >= 1 
                              params[:page].to_i
                            else 
                              1 
                            end, 
                          :per_page => PER_PAGR)
    if @images.size == 0
      flash[:notice] = I18n.t("none", :scope => TRANSLATION_SCOPE)
    end
    
    respond_to do |format|
      format.html { render :layout => 'site_no_navi' }
      format.xml  { render :xml => @images }
    end
  end
  
  
  
  def new
    @image = Image.new
  end
  
  # CREATE /images
  # 画像を新規にアップロード
  def create
    @image = Image.new(:title =>  if params[:image] then 
                                    params[:image][:title]
                                  else
                                    nil
                                  end
                                    )
    @image.site_id = @site.id
    flash[:notice] = ''
    additional_attrs = {:site_id => @site.id,
                        :user => current_user,
      #                :user_id => current_user.id,
      }
    respond_to do |format|
      begin
        if @image = Image.create( additional_attrs.merge params[:image] )
          format.html do 
            @image.update_attributes(params[:image_additional])
            redirect_to(url_for(:action => :index, :display_upload => 1), 
            :notice => I18n.t("created", :scope => TRANSLATION_SCOPE)) 
          end
          format.xml  { render :xml => @image, :status => :created, 
            :location => @image }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @image.errors, 
            :status => :unprocessable_entity }
        end
      rescue => ex
        logger.error("error!", ex)
        format.html { render :action => "new" }
        format.xml  { render :xml => @image.errors, 
          :status => :unprocessable_entity }
      end
    end
    
  end
  
  # EDIT /images/1
  # EDIT /images/1.xml
  def edit
    @image = Image.find_by_id_and_site_id(params[:id], @site.id)
    if @image.nil?
      respond_to do |format|
        format.html { redirect_to(index_url, 
          :notice => I18n.t("not_found", :scope => TRANSLATION_SCOPE)) }
        format.xml  { render :xml => @image.errors, 
          :status => :unprocessable_entity }
      end
      return
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @image }
    end
  end
  
  # UPDATE /images/1
  # UPDATE /images/1.xml
  def update
    @image = Image.find_by_id_and_site_id(params[:id], @site.id)
    if @image.nil?
      respond_to do |format|
        format.html { redirect_to(index_url, 
          :notice => I18n.t("not_found", :scope => TRANSLATION_SCOPE)) }
        format.xml  { render :xml => @image.errors, 
          :status => :unprocessable_entity }
      end
      return
    end
    
    @image.user = current_user
    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html do 
          redirect_to(index_url, 
                  :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE)) 
        end
        format.xml  { render :xml => @image, :status => :updated, 
          :location => @image }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image.errors, 
          :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy
    @image = Image.find_by_id_and_site_id(params[:id], @site.id)
    if @image.nil?
      respond_to do |format|
        format.html { redirect_to(index_url, 
          :notice => I18n.t("not_found", :scope => TRANSLATION_SCOPE)) }
        format.xml  { render :xml => @image.errors, 
          :status => :unprocessable_entity }
      end
      return
    end

    @image.destroy
    respond_to do |format|
      format.html { redirect_to(index_url, 
        :notice => I18n.t("destroyed", :scope => TRANSLATION_SCOPE)) }

      format.xml  { head :ok }
    end
  end  
  
  # SHOW /images/1
  # SHOW /images/1.xml
  # 画像情報の表示
  def show
    @image = Image.find_by_id_and_site_id(params[:id], @site.id)
    if @image.nil?
      respond_to do |format|
        format.html { redirect_to(index_url, 
          :notice => I18n.t("not_found", :scope => TRANSLATION_SCOPE)) }
        format.xml  { render :xml => @image.errors, 
          :status => :unprocessable_entity }
      end
      return
    end
  end
  
  # 一括操作の実行.
  # <操作名>_by_id メソッドで個々のモデル要素の操作を実行していく.
  # == リクエストパラーメーター
  # * [:images][:processing_method] => 操作名(destroy..)
  # * [:images][:checked][:id] => チェックされた画像モデルのid
  def process_with_batch
    # 操作(destroy..)を取得
    processing = params[:images][:processing_method]
    # 処理を行うmethod('<操作>_by_id')の有無をチェック
    if !respond_to?(processing + '_by_id', true)
      return redirect_to(url_for(:action => :index), 
      :notice => I18n.t("not_implemented_batch", :scope => TRANSLATION_SCOPE)) 
    end
    if params[:images][:checked].empty? 
      return redirect_to(url_for(:action => :index)) 
    end
    # checkされた　行ごとの処理
    params[:images][:checked].each do |attr|
      send(processing + '_by_id', attr[1].to_i)
    end
    #
    redirect_to(url_for(:action => :index), 
    :notice => I18n.t("complete_#{processing}_batch", 
      :scope => TRANSLATION_SCOPE,
      :count => params[:images][:checked].size.to_s)) 
  end
  
  
  private
  
  # 一覧ページへのurlを返す
  def index_url
    site_images_path
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
      'created_at' 
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

  # 指定されたidの行を削除
  def destroy_by_id(id)
    Image.delete(id)
  end
  
  protected
  
  # ユーザがこのcontroller の機能を使用可能かどうかを返す.
  # userがnilでなければOKにする.
  def accessible_for?(user)
    !!user
  end


end
