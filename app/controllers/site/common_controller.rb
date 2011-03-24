class Site::CommonController < Site::BaseController
  
  def inaccessible
  end

  # ユーザがこのcontroller の機能を使用可能かどうかを返す.
  # userがnilでなければOKにする.
  def accessible_for?(user)
    !!user
  end
  
end
