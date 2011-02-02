
class Site::ImagesController < Site::BaseController
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "images"].freeze
  
  
  def new
    @image = Image.new
  end
  
  def create
    @image = Image.new(:title => params[:image][:title])
    @image.site_id = current_user.site_id
    flash[:notice] = ''
    additional_attrs = {:site_id => current_user.site_id,
      #                :user_id => current_user.id,
      }
#    @image.attach(params[:image][:image])
    
    respond_to do |format|
#      if @image.save(:validate => true)
      begin
        if @image = Image.create( additional_attrs.merge params[:image] )
          format.html do 
            @image.update_attributes(params[:image_additional])
  #          render :text => "アップロードしました"
            redirect_to(url_for(:action => :new), 
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
  
  
  private
  
  # 一覧ページへのurlを返す
  def index_url
    url_for(:action => :index, 
      :page => if !params[:page].blank? then params[:page] else 1 end,
      :sort => if !params[:sort].blank? then params[:sort] else nil end,
      :direction => if !params[:direction].blank? then params[:direction] else nil end
      )
  end
  
end
