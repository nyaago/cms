# = Admin::InformationController
# 管理者からのお知らせの一覧、編集
class Admin::InformationController < Admin::BaseController
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "admin", "information"].freeze

  def index
    @information = Information.order("updated_at desc")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @information }
    end
  end

  # GET admin/information/edit/id
  # お知らせ編集
  def edit
    flash[:notice] = ''
    @information = Information.where("id = :id", :id => params[:id]).first
    if @information.nil?
      flash[:notice] = I18n.t :not_found, :scape => TRANSLATION_SCOPE
    end
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @information }
    end
  end
  
  # GET admin/information/new
  # お知らせ新規編集
  def new
    flash[:notice] = ''
    @information = Information.new
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @information }
    end
  end
  
  # POST admin/information/update/<id>
  # お知らせ更新
  def update
    @information = Information.where('id = :id', :id => params[:id]).
                              first
    if @information.nil?
      respond_to do |format|
        flash[:notice] = I18n.t :not_found, :scope => TRANSLATION_SCOPE
        format.html { render :action => :edit}
        format.xml  { render :xml => "NG", 
                :status => :unprocessable_entity }
      end
      return
    end
    @information.updated_by = current_user
    respond_to do |format|
      if @information.update_attributes(params[:information])
        flash[:notice] = I18n.t :updated, :scope => TRANSLATION_SCOPE
        format.html { redirect_to :action => :index }
        format.xml  { render  :xml => @information  }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @information.errors, 
          :status => :unprocessable_entity }
      end
    end
  end

  # POST admin/information/create
  # お知らせ作成
  def create
    @information = Information.new(params[:information])
    if @information.nil?
      respond_to do |format|
        format.html { render :action => :new}
        format.xml  { render :xml => "NG", 
                :status => :unprocessable_entity }
      end
      return
    end
    @information.updated_by = current_user
    respond_to do |format|
      if @information.save(:validate => true)
        flash[:notice] = I18n.t(:created, :scope => TRANSLATION_SCOPE)
        format.html { redirect_to :action => :index }
        format.xml  { render  :xml => @information  }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @information.errors, 
          :status => :unprocessable_entity }
      end
    end
  end
  
  # POST admin/information/destroy/<id>
  # お知らせ削除
  def destroy
    @information = Information.where('id = :id', :id => params[:id]).
                              first
    if @information.nil?
      respond_to do |format|
        format.html { render :action => :index}
        format.xml  { render :xml => "NG", 
                :status => :unprocessable_entity }
      end
      return
    end
    @information.destroy
    flash[:notice] = I18n.t :destroyed, :scope => TRANSLATION_SCOPE
    respond_to do |format|
      format.html { redirect_to(:action => :index) }
      format.xml  { render status }
    end
  end
  
  protected
  
  # ユーザがこのcontroller の機能を使用可能かどうかを返す.
  # userがnilでなければOKにする.
  def accessible_for?(user)
    !!user
  end
  
  
end
