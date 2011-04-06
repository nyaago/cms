class Site::CommonController < Site::BaseController

  # 機能に対するアクセス不可報告ページを表示
  def inaccessible
  end

  # 解約時のページ表示
  def canceled 
    render :layout => 'site_no_login'
  end
  
  # 使用停止時のページ表示
  def suspended
    render :layout => 'site_no_login'
  end
  
  protected

  # ユーザがこのcontroller の機能を使用可能かどうかを返す.
  # userがnilでなければOKにする.
  def accessible_for?(user)
    !!user
  end
  
  # login していないときにアクセス可能かどうかを返す.
  def accessible_unless_login?
    # p "accessible ? #{!(params[:action] == 'inaccessible')}"
    !(params[:action] == 'inaccessible')
  end
  
end
