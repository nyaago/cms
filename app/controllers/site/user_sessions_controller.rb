# = Site::UserSessionsController
# ユーザセッションのコントローラー.
# ログイン、ログアウトを実装.
class Site::UserSessionsController  < Site::BaseController
  
  skip_before_filter :authenticate
  
  # 空の新規ユーザセッション(UserSession)を生成.
  # ログインページを表示.
  def new
    @user_session = UserSession.new
    render :layout => 'site_no_navi'
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
      redirect_back_or_default :dashboard, @user_session.user.site.name
    else
      render :action => :new
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
  
end
