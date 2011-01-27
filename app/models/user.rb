# = User
# サイトユーザのモデル
class User < ActiveRecord::Base

  belongs_to :site, :readonly => true

  # 認証を行うモデルとしての拡張
  acts_as_authentic do |config|
    #
    #
    config.crypto_provider = Authlogic::CryptoProviders::MD5
  end

end
