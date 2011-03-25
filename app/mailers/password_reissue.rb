# = PasswordReissue
# パスワード再発行URLを通知するメイルの作成
class PasswordReissue < ActionMailer::Base

    require 'kconv'

    TRANSLATION_SCOPE  = [:mailer, :inquiry, :contact, :subject]

    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.raise_delivery_errors = true
    ActionMailer::Base.default_url_options[:host] = "localhost:3000"

    # configファイル(config/email.yml) をload.
    # Hashで内容を返す
    def self.load_config
      yaml = nil
      begin
        yaml = YAML.load_file(config_path)
      rescue  => ex
        logger.debug "failed in reading yaml (#{file})"
      end
      if yaml.nil?
        logger.debug "failed in reading yaml (#{file})"
      end
      yaml
    end

    # 一覧設定ファイル(yaml)ファイルを配置するパス
    def self.config_path
      ::Rails.root.to_s + "/config/email.yml"
    end

    # 設定を読み込み、smtpの設定を行う.
    config = load_config
    ActionMailer::Base.smtp_settings = {
      :from =>  config['from'],
      :port => config['port'],
      :address => config['address'],
      :domain => config['domain'],
      :user_name => config['user_name'],
      :password => config['password'],
      :authentication => config['authentication'],
      :enable_starttls_auto => config['tls'] == "true"
    }
    @@default_charset = 'iso-2022-jp'
    default :charset => 'iso-2022-jp'
    @@encode_subject  = false

    # 再発行URLを通知するメイルの作成
    # = parameters
    # * user => user モデル record
    # * request => http request 
    # * expiration_minute => 再発行操作の期限(分数)
    def reissue_email(user, request, expiration_minute)
      @user =user
      @request = request
      @expiration_minute = expiration_minute

      subject = I18n.t("subject",:scope => [:mailer, :password_reissue, :reissue])
      #subject = "".force_encoding('iso-2022-jp')

      mail(:to => @user.email,
        :subject => subject) do |format|        
        format.text
      end  
    end

    protected

end
