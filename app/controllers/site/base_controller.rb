# = Site::BaseController
# サイトユーザの操作に関わるコントローラーのベース.
# 認証などの共通処理を定義
class Site::BaseController < ActionController::Base
  
  protect_from_forgery # :except => :hoge
  
  layout "site"
  # action  の before filter. 
  # 認証確認
  before_filter :authenticate
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = [:messages, :site].freeze

  
  protected

  # 現在ログインしているユーザセッション情報を得る
  def current_user_session
    @current_user_session ||= UserSession.find
  end
  
  # 現在ログインしているユーザの情報(User)を得る
  # 
  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end
  
  # 認証の確認.
  # 認証されていなければ、ログインページへのリダイレクト.
  # また、権限がなければ、権限エラーのページへリダイレクト.
  def authenticate
    if current_user.nil? || current_user.site.name != params[:site]
      store_location
      flash[:notice] = I18n.t :need_to_login, 
                              :scope => TRANSLATION_SCOPE + [:user_sessions]
      redirect_to :controller => :user_sessions, :action => :new,
                  :back_controller => params[:controller],
                  :site => params[:site]
      return false
    end
    @site = current_user.site
    @current_user = current_user
    unless accessible_for?(@current_user)
      redirect_to :controller => :common, :action => :inaccessible
      return false
    end
    return true
  end
  
  # 要求されたuriをセッションの保存.
  # 認証ページをはさむ場合に,戻り先となるuriを保存するのが目的.
  def store_location
    session[:return_to] = request.request_uri
  end

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
  
  protected
  
  # ユーザがこのcontroller の機能を使用可能かどうかを返す.
  # ここでは、管理者とサイト内管理者のみが使用可能とする。
  # 可能な権限を変更する場合は、継承先でオーバーライドする
  def accessible_for?(user)
    user.is_admin || user.is_site_admin
  end
  
end
