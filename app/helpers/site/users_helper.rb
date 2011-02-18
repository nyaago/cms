# Site::UsersHelper
# 
module Site::UsersHelper

  def users_path
    if params[:action] == 'new'
      url_for(:controller => 'users', :action => 'create')
    else
      url_for(:controller => 'users', :action => 'index')
    end
  end

  def user_path(id)
    if params[:action] == 'edit'
      url_for(:controller => 'users', :action => 'update', :id => params[:id])
    else
      url_for(:controller => 'users', :action => 'show', :id => params[:id])
    end
  end
  
  def new_user_path
    url_for(:controller => 'users', :action => 'new')
  end
  
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
  

end
