# SiteAdmin::UsersHelper
# 
module SiteAdmin::UsersHelper

  def site_users_path
    if params[:action] == 'new'
      url_for(:controller => 'users', :action => 'create')
    else
      url_for(:controller => 'users', :action => 'index')
    end
  end

  # Userに対するurlパスを返す.
  # Userは,Userモデルまたは、id値.nil指定で省略.
  # == options
  # :action => action.デフォルトは,'show'
  def site_user_path(user = false, options = {})
    if params[:action] == 'edit' || params[:action] == 'update' 
      url_for(:controller => 'users', :action => 'update', 
              :id => 
                if user
                  if user.respond_to(:id) then user.id else user end
                else
                  params[:id]
                end
                )
                    
    elsif params[:action] == 'new' || params[:action] == 'create'
      url_for(:controller => 'users', :action => 'create')
    else
      url_for(:controller => 'users', :action => 'show', 
              :id => 
                if user
                  if user.respond_to(:id) then user.id else user end
                else
                  params[:id]
                end
                )
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
