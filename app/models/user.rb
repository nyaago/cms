# = User
# サイトユーザのモデル
class User < ActiveRecord::Base

  belongs_to :site
  belongs_to :updated_by, :readonly => true, :class_name => "User"
  
  # 管理が少なくとも１人存在するかの検証
  validates_with Validator::User::SiteAdminExist
  

  # 認証を行うモデルとしての拡張
  acts_as_authentic do |config|
    #
    #
    config.crypto_provider = Authlogic::CryptoProviders::MD5
  end

end
