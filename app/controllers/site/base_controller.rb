# = Site::BaseController
# サイトユーザの操作に関わるコントローラーのベース.
# 認証などの共通処理を定義
class Site::BaseController < ApplicationController
  
  before_filter :authenticate
  
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
  # 認証されていなければ、ログインページへのリダイレクト
  def authenticate
    unless current_user
      store_location
      flash[:notice] = I18n.t :need_to_login, :scope => [:messages, :site]
      redirect_to '/site/user_sessions/new'
      return false
    end
    return true
  end
  
  # 要求されたuriをセッションの保存.
  # 認証ページをはさむ場合に,戻り先となるuriを保存するのが目的.
  def store_location
    session[:return_to] = request.request_uri
  end

  # セッションに保存されている戻り先,またはデフォルトのuriへのリダイレクト
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end
