# = User
# ユーザのモデル
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

  # パスワード再発行用パスワードの生成
  def generate_reissue_password
    src_str = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a

    password = nil
    begin
      password = String.new
      30.times {
      	random_num = rand(src_str.length)
      	password += src_str[random_num].chr
      }
    end while User.select('id').
    where("reissue_password = :reissue_password", :reissue_password => password).size > 0
    self.reissue_password = password
  end
  
  # 唯一の管理者ユーザであるか?
  def only_admin?
    self.is_admin && User.where("is_admin = true").where("id <> :id", :id => self.id).count == 0
  end

  # 唯一のサイト管理者ユーザであるか?
  def only_site_admin?
    self.is_site_admin && 
      User.where("is_site_admin = true").
      where("site = :site", :site => self.site_id).
      where("id <> :id", :id => self.id).count == 0
  end

end


