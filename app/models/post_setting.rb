require 'reversible_cipher'
# email の validator を読み込む
require 'domain_validator' 

# = PostSetting
# 投稿設定
class PostSetting < ActiveRecord::Base

  @@password_for_cipher = Rails.application.config.secret_token_for_pop3_password

  # 暗号化、複合化モジュールをinclude
  # see lib/reversile_cipher
  include ::ReversibleCipher

  # 新規作成前のフィルターdefault 値の設定.
  before_create :set_default

  before_save   :crypt_password
  
  # サイトへの所属関連
  belongs_to :site

  # validator
  validates :pop3_host, :domain => true, 
      :if => Proc.new { |setting| !setting.pop3_host.blank? }
  # 名前がサイト内でUniquであるのValidation  
  validates_with Validator::PostSetting::Pop3Consistency
  

  # pop3パスワードを返す.
  # @pop3_passwordで設定されていなければ,pop3_crypted_password属性から復号化
  def pop3_password
    @pop3_password = if @pop3_password.blank?  && 
          !self.pop3_crypted_password.blank? &&
          !self.pop3_password_salt.blank?
      decrypt([self.pop3_crypted_password].pack("H*").force_encoding("ASCII-8BIT"), 
              @@password_for_cipher,
              [self.pop3_password_salt].pack("H*").force_encoding("ASCII-8BIT")).
          force_encoding("UTF-8")
    else
      @pop3_password
    end
    @pop3_password
  end

  # pop3のパスワードを設定.
  # 暗号化して、pop3_crypted_password属性への設定も行う.
  def pop3_password= (password)
    @pop3_password = password
    if @pop3_password.blank? 
      self.pop3_password_salt = nil
      self.pop3_crypted_password = nil
    end
    
    password_salt = salt
    self.pop3_password_salt = password_salt.unpack("H*").join.force_encoding("UTF-8")
    self.pop3_crypted_password =  
        encrypt(@pop3_password, @@password_for_cipher,password_salt).
        unpack("H*").join.force_encoding("UTF-8")
    
    p "password = #{self.pop3_crypted_password}"
    
  end


  protected
  
  # default 値の設定
  def set_default
    self.editor_row_count = 10
  end

  def crypt_password
  end
  
end