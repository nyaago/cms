# = UserSessionsController
# ユーザセッションのコントローラー.
# ログイン、ログアウトを実装.
class UserSessionsController  < ActionController::Base
  
  protect_from_forgery # :except => :hoge
#  skip_before_filter :authenticate
  
  # 空の新規ユーザセッション(UserSession)を生成.
  # ログインページを表示.
  def new
    @user_session = UserSession.new
    render :layout => 'no_login'
  end

  def index
    redirect_to :action => :new
  end

  
  # ログインのための情報（ログイン,パスワード）をリクエストパラメーターから得て,
  # ユーザーセッションを生成,保存.
  # ログイン情報が不正であれば,ログインページを表示.
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      @user_session.user.auto_login = params[:user][:auto_login]
      @user_session.user.save(:validate => false)
      if @user_session.user.is_admin
        redirect_back_or_default 'admin/sites'
      else
        redirect_back_or_default 'site/dashboard', @user_session.user.site.name
      end
    else
      render :action => :new, :layout => 'no_login'
    end
  end
  
  # ログアウト.
  # ユーザセッションを削除.ログインページを表示.
  def destroy
    if current_user_session
      current_user_session.destroy
    end
    redirect_to :controller => :user_sessions, :action => :new
  end
  
protected 

  # back_controller で指定されているcontroller の index,
  # またはデフォルトのuriへのリダイレクト
  def redirect_back_or_default(default_controller, default_site = nil)
    redirect_to(:controller =>  if params[:back_controller].blank? 
                                  default_controller
                                else
                                  params[:back_controller]
                                end,
                :action => :index,
                :site => if params[:site].blank? then  default_site else params[:site] end
                  )

#    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # 現在ログインしているユーザセッション情報を得る
  def current_user_session
    @current_user_session ||= UserSession.find
  end
  
  # 現在ログインしているユーザの情報(User)を得る
  # 
  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end
  
  
end
