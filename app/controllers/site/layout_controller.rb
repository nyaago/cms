# == Site::LayoutController
# レイアウトテーマの選択
class Site::LayoutController < Site::BaseController
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "layout"].freeze
  
  # indexページ
  # 各レイアウト設定を行うページを表示
  def index
    @site = current_user.site
    @site_layout = @site.site_layout
    @footer_image = LayoutImage.new
    @header_image = LayoutImage.new
    @logo_image = LayoutImage.new
    @background_image = LayoutImage.new
    @layout_defs = Layout::DefinitionArrays.new
  end
  
  # layout/update/1
  # layout/update/1.xml
  # レイアウトフォームの内容でlayout モデル更新.
  def update
    @site = Site.find_by_id( current_user.site_id)
    if @site.nil? || @site.site_layout.nil?
      # site not found
      respond_to do |format|
        @site_layout = @site.site_layout
        @layout_defs = Layout::DefinitionArrays.new

        flash[:notice] = I18n.t("not_found", :scope => TRANSLATION_SCOPE)
        format.html { 
          render :action => "index" }
        format.xml  { render :xml => @site.errors, 
          :status => :unprocessable_entity }
        return
      end
    end
    # 属性設定
#    @site.user_id = current_user.id
    @site.site_layout.attributes = params[:site_layout]

    respond_to do |format|
      # 画像登録 + site_layoutモデルの登録
      if create_images(@site.site_layout) && 
        @site.site_layout.save(:validate => true) 
        # 
        remove_checked_images(@site.site_layout)
        # 古い画像削除
        remove_previos_revison_images
        #
        format.html { redirect_to(index_url, 
          :notice => I18n.t("updated", :scope => TRANSLATION_SCOPE))}
        format.xml  { head :ok }
      else
        @site_layout = @site.site_layout
        @layout_defs = Layout::DefinitionArrays.new
        format.html { render :action => "index" }
        format.xml  { render :xml => @site.errors, 
          :status => :unprocessable_entity }
      end
    end
  end
    
  private 
  
  # 一覧ページへのurlを返す
  def index_url
    url_for(:action => :index)
  end
  
  # 各画像(header, footer, logo, background)の登録
  # layout_imageモデルへの登録とファイルシステム上への配置.
  # 各画像モデルのインスタンス作成も行う.
  # 成功すればtrue, エラーがあればfalseを返す
  def create_images(site_layout)
    header_register = ImageRegister.new(params[:header], current_user, 'header')
    if header_register.create
      site_layout.header_image_url = header_register.url
    end
    @header_image = header_register.image
    footer_register = ImageRegister.new(params[:footer], current_user, 'footer')
    if footer_register.create 
      site_layout.footer_image_url = footer_register.url
    end
    @footer_image = footer_register.image

    background_register = ImageRegister.new(params[:background], current_user, 'background')
    if background_register.create 
      site_layout.background_image_url = background_register.url
    end
    @background_image = background_register.image

    logo_register = ImageRegister.new(params[:logo], current_user, 'logo')
    if logo_register.create 
      site_layout.logo_image_url = logo_register.url
    end
    @logo_image = logo_register.image


    (!header_register.has_error? && 
    !footer_register.has_error? && 
    !background_register.has_error? &&
    !logo_register.has_error?)
  end
  
  # 各画像で、削除のチェックがされているものを削除
  # == parameters
  # * site_layout - SiteLayoutモデル
  def remove_checked_images(site_layout)
    updated = false
    ['header', 'footer', 'logo', 'background'].each do |loc|
      updated |= remove_checked_image(site_layout, loc)
    end
    if updated
      site_layout.save(:validate => false )
    end
  end
  
  # 削除のチェックがされている画像を削除
  # layout_imageからの削除,ファイルシステムからの削除. 及び,site_layoutモデル の urlをクリア
  # == parameters
  # * site_layout - SiteLayoutモデル
  # * location_type - 'header'/'footer'/'logo'/'background'
  def remove_checked_image(site_layout, location_type)
    if params[:delete_image][location_type.to_sym].to_i == 1
      images = @site.layout_images.
                    where('location_type = :location_type', :location_type => location_type).
                    order('updated_at desc')
      images.each_with_index do |image, index|
        image.destroy
      end
      site_layout.send("#{location_type}_image_url=", nil)
      true
    else
      false
    end
  end
    
  
  # 最新以外の各画像の削除
  def remove_previos_revison_images
    ['header', 'footer', 'logo', 'background'].each do |loc|
      remove_previos_revison_image(loc)
    end
  end
  
  # 最新以外の画像の削除
  # == parameters
  # * location_type - 画像の配置タイプ('header','footer','logo','background')
  def remove_previos_revison_image(location_type)
    images = @site.layout_images.
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
    def initialize(file_params, current_user, type)
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
      additional_attrs = {:site_id => @current_user.site_id, :location_type => @type}
      @image = LayoutImage.new( additional_attrs.merge @file_params )
      
      @image.save(:validate => true)
    end
    
    # 
    def has_error?
      !@image  || !!@image.errors.any?
    end
    
    #
    def image
      @image
    end
    
    #
    def url 
      if @image
        @image.url
      else
        nil
      end
    end
    
  end
  
end
