# = Site::PasswordReissueController
# パスワード再発行
class Site::PasswordReissueController < ActionController::Base
  
  layout 'site_no_login'
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "password_reissue"].freeze
  
  # パスワード再発行URLが有効な期限(分)
  PASSWORD_EXPIRATION_MINUTE = 30
  
  # パスワード再発行を要求するページを表示
  def index
    @user = nil
  end
  
  # POST site/password_reissue
  # パスワード再発行を要求.
  # 再発行用パスワード(User.reissue_password)の生成とメイルでの再発行用URLの通知を行う.
  # リクエストパラメータとして以下を受ける
  # * user[login]  login id
  def ask
    @user = User.where("login = :login", :login => params[:user][:login]).first
    if @user.nil?
      flash[:error] = I18n.t :unknown_account, :scope => TRANSLATION_SCOPE
      respond_to do |format|
        format.html do 
          render :action => :index
        end
      end
      return
    end
    @user.generate_reissue_password 
    @user.save!(:validate => false)
    begin
      PasswordReissue.reissue_email(@user, request, PASSWORD_EXPIRATION_MINUTE).deliver
      respond_to do |format|
        format.html do 
          flash[:notice] = I18n.t :accept, :scope => TRANSLATION_SCOPE, 
                                :minute => PASSWORD_EXPIRATION_MINUTE
          redirect_to :action => :accept
        end
      end
    rescue => ex
      p ex.message
      p ex.backtrace
      respond_to do |format|
        format.html do 
          flash[:notice] = I18n.t :failed_in_sending, :scope => TRANSLATION_SCOPE
          render :action => :index
        end
      end
    end
  end
  
  # パスワード再発行要求を受け付けた
  # 受付完了ページの表示
  def accept
  end
  
  # パスワード再発行ページを表示
  # GET site/password_reissue/edit/?reissue_password=<reissue_password>
  def edit
    @user = User.new(:reissue_password => params[:reissue_password])
    respond_to do |format|
      format.html 
      format.xml { render :xml => @user }
    end
    
  end
  
  # パスワードを再発行.login アカウント, 再発行用パスワードをチェックして有効なら送信された内容で再発行を行う.
  # 再発行後,完了ページへリダイレクト.
  # POST site/password_reissue/update
  # 以下のリクエストパラメータを受ける
  # * user[login]
  # * user[reissue_password ]
  # * user[password ]
  # * user[password_confirmation ]
  def update
    @user = User.find_by_login(params[:user][:login])
    if @user == nil
      @user = User.new(params[:user])
      respond_to do |format|
        format.html do
          flash[:error] = I18n.t :unknown_account, :scope => TRANSLATION_SCOPE
          render :action => :edit
        end  
        format.xml  { render :status => 'NG' }
      end
      return
    end
    if  @user.reissue_password != params[:user][:reissue_password] ||
        (Time.now - @user.updated_at) > PASSWORD_EXPIRATION_MINUTE.minute
      @user.reissue_password = params[:user][:reissue_password] 
      respond_to do |format|
        format.html do
          flash[:error] = I18n.t :invalid_reissue_access, :scope => TRANSLATION_SCOPE
          render :action => :edit
        end  
        format.xml  { render :status => 'NG' }
      end
      return
    end
    begin
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      @user.save(:validate => true)
      respond_to do |format|
        format.html  do 
          flash[:notice] = I18n.t :password_reissued, :scope => TRANSLATION_SCOPE
          redirect_to :action => :completed 
        end
        format.xml { render :status => 'OK' }
      end
    rescue
      respond_to do |format|
        format.html { render :action => :edit }
        format.xml { render :status => 'OK' }
      end
    end
    @user.reissue_password = ''
    @user.save(:validate => false)
  end
  
  def completed
  end
  
end
