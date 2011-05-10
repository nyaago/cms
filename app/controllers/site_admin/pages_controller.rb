# = SiteAdmin::PagesController
# 記事作成関連のコントローラー
class SiteAdmin::PagesController < SiteAdmin::ArticlesController

  helper :all

  # 記事履歴の表示件数制限
  LIMIT_HISTORY = 20
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site_admin", "pages"].freeze

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
        @article.reload
        # ヘッダー画像保存, 保存された内容を参照して、articleのheader_image_url属性も更新.
        if create_images(@article)
          # 容量オーバーの場合
          if cancel_uploading_images_if_over_capacity
            @layout_defs = Layout::DefinitionArrays.new
            flash[:warning] = I18n.t "over_capacity", :scope => TRANSLATION_SCOPE
            format.html { render :action => "index" }
            format.xml  { render :xml => @site.errors, 
              :status => :unprocessable_entity }
            return
          end
          if @article.changed?
            @article.save(:validate => false)
          end
          format.html { redirect_to(index_url, 
            :notice => I18n.t("created", :scope => TRANSLATION_SCOPE)) }
          format.xml  { render :xml => @article, :status => :created, 
            :location => @article }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @article.errors, 
            :status => :unprocessable_entity }
        end
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
        flash[:warning] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
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
    history_saved = false
    respond_to do |format|
      # 変更されていれば、履歴を作成
      if @article.changed? then
        save_history_from(article_before_update)
        history_saved = true
      end
      if @article.save(:validate => true)
        @article.reload
        # ヘッダー画像保存, 保存された内容を参照して、articleのheader_image_url属性も更新.
        if create_images(@article)
          # 容量オーバーの場合
          if cancel_uploading_images_if_over_capacity
            @layout_defs = Layout::DefinitionArrays.new
            flash[:warning] = I18n.t "over_capacity", :scope => TRANSLATION_SCOPE
            format.html { render :action => "index" }
            format.xml  { render :xml => @site.errors, 
              :status => :unprocessable_entity }
            return
          end
          if @article.changed?
            @article.save(:validate => false)
            if history_saved == false
              save_history_from(article_before_update)
            end
            remove_previos_revison_images
          end
        end
        # 画像削除チェックされていれば削除
        remove_checked_images(@article)
        
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
  
  # 記事履歴一覧を得る
  def article_histories
    @site.page_histories
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
  
  # 各画像(header)の登録
  # layout_imageモデルへの登録とファイルシステム上への配置.
  # 各画像モデルのインスタンス作成も行う.
  # 成功すればtrue, エラーがあればfalseを返す
  def create_images(article)
    header_register = ImageRegister.new(article, params[:header], current_user, 'header')
    if header_register.create
      article.header_image_url = header_register.url
    end
    @header_image = header_register.image
    !header_register.has_error?
  end
  
  # 使用容量が超えた場合は,アップロードした画像を削除
  # 削除した場合はtrue, 層でない場合はfalse
  def cancel_uploading_images_if_over_capacity
    if @site.used_capacity - capacity_previos_revison_images  > 
            @site.max_mbyte * 1024 * 1024
      if @header_image 
        @header_image.destroy
      end
      true
    end
    false
  end
  
  # 最新以外の各画像の容量合計
  def capacity_previos_revison_images
    size = 0
    ['header'].each do |loc|
      size += capacity_previos_revison_image(loc)
    end
    size
  end
  
  # 最新以外の画像の容量
  # == parameters
  # * location_type - 画像の配置タイプ('header','footer','logo','background')
  def capacity_previos_revison_image(location_type)
    images = @article.layout_images.
                  where('location_type = :location_type', :location_type => location_type)
    size = 0
    images.each_with_index do |image, index|
      if index != 0 
        size += image.image_file_size
      end
    end
    size 
  end
  
  
  # 各画像で、削除のチェックがされているものを削除
  # == parameters
  # * site_layout - SiteLayoutモデル
  def remove_checked_images(article)
    updated = false
    ['header'].each do |loc|
      updated |= remove_checked_image(article, loc)
    end
    if updated
      article.save(:validate => false )
    end
  end
  
  # 削除のチェックがされている画像を削除
  # layout_imageからの削除,ファイルシステムからの削除. 及び,site_layoutモデル の urlをクリア
  # == parameters
  # * site_layout - SiteLayoutモデル
  # * location_type - 'header'/'footer'/'logo'/'background'
  def remove_checked_image(article, location_type)
    if params[:delete_image][location_type.to_sym].to_i == 1
      images = @article.layout_images.
                    where('location_type = :location_type', :location_type => location_type).
                    order('updated_at desc')
      images.each_with_index do |image, index|
        image.destroy
      end
      article.send("#{location_type}_image_url=", nil)
      true
    else
      false
    end
  end
    
  
  # 最新以外の各画像の削除
  def remove_previos_revison_images
    ['header'].each do |loc|
      remove_previos_revison_image(loc)
    end
  end
  
  # 最新以外の画像の削除
  # == parameters
  # * location_type - 画像の配置タイプ('header','footer','logo','background')
  def remove_previos_revison_image(location_type)
    images = @article.layout_images.
                  where('location_type = :location_type', :location_type => location_type).
                  order('updated_at desc')
    images.each_with_index do |image, index|
      if index != 0 
        image.destroy
      end
    end
  end
  
  
  
  
  # = LayoutController::ImageRegister
  # 画像登録
  class ImageRegister
  
    # 初期化
    # == parameters
    # * file_params - Postされた画像情報パラメター.
    # * current_user - 現在のユーザ. Userモデルインスタンス
    # * type - location type('header','footer','logo','background',)
    def initialize(article, file_params, current_user, type)
      @article = article
      @file_params = file_params
      @current_user = current_user
      @image = LayoutImage.new
      @type = type
    end

    # 画像の登録.DBのモデルの行への情報登録とファイルシステム上への配置
    # 登録が行われた場合は登録したmodelを返す.
    # （フォームで指定されなかったための）未登録、及びエラーの場合は　falseを返す
    def create
      return false if @file_params.nil?
      additional_attrs = {:site_id => @article.site.id, :article_id => @article.id, 
                          :location_type => @type}
      @image = LayoutImage.new( additional_attrs.merge @file_params )
      @image.save(:validate => true)
    end
    
    # エラーがある?
    def has_error?
      !@image  || !!@image.errors.any?
    end
    
    # image
    def image
      @image
    end
    
    # 画像 url
    def url 
      if @image
        @image.url
      else
        nil
      end
    end
    
  end
  
  
end
