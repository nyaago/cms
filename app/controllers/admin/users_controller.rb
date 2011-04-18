# = Admin::UserController 
# サイトユーザの管理
class Admin::UsersController < Admin::BaseController
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "admin", "users"].freeze
  
  # 
  # GET /site/users
  # GET /site/users.xml
  def index
    @users = User.select("id, login, email, is_admin").
                      where("is_admin = true").
                      order("is_admin desc, last_request_at desc, updated_at desc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /site/users/1
  # GET /site/users/1.xml
  def show
    @user = User.where("id = :id", :id => params[:id]).
                where('is_admin = true').
                first
    if @user.nil?
      flash[:notice] = I18n.t :not_found, :scope => TRANSLATION_SCOPE
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
    @user = User.where("id = :id", :id => params[:id]).
                where('is_admin = true').
                first
    if @user.nil?
      flash[:notice] = I18n.t :not_found, :scope => TRANSLATION_SCOPE
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /site/users
  # POST /site/users.xml
  def create
    @user = User.new(:login => params[:user][:login], 
                    :password => params[:user][:password],
                    :password_confirmation => params[:user][:password_confirmation],
                    :email => params[:user][:email],
                    :is_admin => true
                    )
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
    @user = User.where("id = :id", :id => params[:id]).
                where('is_admin = true').
                first
    if @user.nil?
      format.html { render :action => "edit" }
      format.xml  { render :xml => "NG", :status => :unprocessable_entity }
      return 
    end
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
    status = :ok
    @user = User.where("id = :id", :id => params[:id]).
                where('is_admin = true').
                first
    if @user
      if @user.only_admin?
        flash[:notice] = I18n.t :only_admin, :scope => TRANSLATION_SCOPE
        status = :ng
      elsif @user == current_user
        flash[:notice] = I18n.t :current_user, :scope => TRANSLATION_SCOPE
        status = :ng
      else
        @user.destroy
      end
    end
    respond_to do |format|
      format.html { redirect_to(:action => :index) }
      format.xml  { render status }
    end
  end
  
end
