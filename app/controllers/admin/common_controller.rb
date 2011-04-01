class Admin::CommonController < Admin::BaseController

  # 機能に対するアクセス不可報告ページを表示
  def inaccessible
  end
  
  protected

  # ユーザがこのcontroller の機能を使用可能かどうかを返す.
  # userがnilでなければOKにする.
  def accessible_for?(user)
    !!user
  end
  

end
