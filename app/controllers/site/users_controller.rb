# = Site::UserController 
# サイトユーザの管理
class Site::UsersController < Site::BaseController
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "users"].freeze
  
  # 
  # GET /site/users
  # GET /site/users.xml
  def index
    @users = @site.users.select("id, login, email, is_admin").
                          order("is_admin desc, last_request_at desc, updated_at desc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /site/users/1
  # GET /site/users/1.xml
  def show
    @user = User.find_by_id(params[:id])
    if @user.nil?
      render :file => "#{::Rails.root.to_s}/app/views/404.html.erb", :layout => false
      return
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /site/users/new
  # GET /site/users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /site/users/1/edit
  def edit
    @user = User.find_by_id(params[:id])
    if @user.nil?
      render :file => "#{::Rails.root.to_s}/app/views/404.html.erb", :layout => false
      return
    end
  end

  # POST /site/users
  # POST /site/users.xml
  def create
    @user = User.new(:login => params[:user][:login], 
                    :password => params[:user][:password],
                    :password_confirmation => params[:user][:password_confirmation],
                    :email => params[:user][:email]
                    )
    @user.site_id = current_user.site_id
    @user.updated_by = current_user
    respond_to do |format|
      if @user.save
        flash[:notice] = I18n.t :created, :scope => TRANSLATION_SCOPE
        format.html { redirect_to(:action => :index)}
      else
        format.html { render  :action => "new" }
        format.xml  { render :xml => @user.errors, 
                              :status => :unprocessable_entity }
      end
    end
  end

  # PUT /site/users/1
  # PUT /site/users/1.xml
  def update
    @user = User.find(params[:id])
    @user.updated_by = current_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = I18n.t :updated, :scope => TRANSLATION_SCOPE
        format.html { redirect_to(:action => :index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /site/users/1
  # DELETE /site/users/1.xml
  def destroy
    @user = User.find(params[:id])
    if @user
      @user.destroy
    end
    respond_to do |format|
      format.html { redirect_to(:action => :index) }
      format.xml  { head :ok }
    end
  end
  
end
