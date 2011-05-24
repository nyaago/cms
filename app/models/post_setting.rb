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
  before_create :set_default!

  before_save   :crypt_password
  
  # サイトへの所属関連
  belongs_to :site
  belongs_to :user, :readonly => true, :foreign_key => :updated_by

  # validator
  validates :pop3_host, :domain => true, 
      :if => Proc.new { |setting| !setting.pop3_host.blank? }
  # pop3設定の整合性Validation(未入力がないか?)
  validates_with Validator::PostSetting::Pop3Consistency
  
  validates_numericality_of :pop3_port, 
      :unless => Proc.new { |post_setting| post_setting.pop3_port.blank? }

  # 保存前のフィルター
  # 各属性の不要な前後空白をぬく
  before_save :strip_attributes!


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
    if password.blank?
      self.pop3_crypted_password = nil
      return password;
    end
    @pop3_password = password.strip_with_full_size_space
    if @pop3_password.blank? 
      self.pop3_password_salt = nil
      self.pop3_crypted_password = nil
    end
    
    password_salt = salt
    self.pop3_password_salt = password_salt.unpack("H*").join.force_encoding("UTF-8")
    self.pop3_crypted_password =  
        encrypt(@pop3_password, @@password_for_cipher,password_salt).
        unpack("H*").join.force_encoding("UTF-8")
        
  end


  protected
  
  # default 値の設定
  def set_default!
    self.editor_row_count = 10
    self.pop3_port = 110
  end

  def crypt_password
  end

  # 各属性の不要な前後空白をぬく
  def strip_attributes!
    !pop3_host.nil? && pop3_host.strip_with_full_size_space!
    !pop3_login.nil? && pop3_login.strip_with_full_size_space!
    true
  end
  
end
