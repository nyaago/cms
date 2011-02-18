# 
#
class Site::UsersController < Site::BaseController
  # GET /admin/users
  # GET /admin/users.xml
  def index
    @users = User.find_all_by_site_id(current_user.site_id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /admin/users
  # POST /admin/users.xml
  def create
    @user = User.new(:login => params[:user][:login], 
                    :password => params[:user][:password],
                    :password_confirmation => params[:user][:password_confirmation],
                    :email => params[:user][:email]
                    )
    @user.site_id = current_user.site_id
    respond_to do |format|
      if @user.save
        flash[:notice] = 'created'
        format.html { redirect_to(:action => :index)}
      else
        format.html { render  :action => "new" }
        format.xml  { render :xml => @user.errors, 
                              :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'updated'
        format.html { redirect_to(:action => :index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(:action => :index) }
      format.xml  { head :ok }
    end
  end
  
end
