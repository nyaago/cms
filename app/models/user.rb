# = User
# サイトユーザのモデル
class User < ActiveRecord::Base

  # 認証を行うモデルとしての拡張
  acts_as_authentic do |config|
    #
    #
    config.crypto_provider = Authlogic::CryptoProviders::MD5
  end

end
