# = UserSession
# ログイン情報を格納するモデル
class UserSession < Authlogic::Session::Base
  
  # 
  def to_key
    [session_key]
  end

end