class InquiryMailer < ActionMailer::Base
  default :from => "from@example.com"

#require "smtp_tls"
  
  require 'kconv'
  
  TRANSLATION_SCOPE  = [:mailer, :inquiry, :contact, :subject]
  
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.default_url_options[:host] = "localhost:3000"

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
   
  def contact_email(form, site)
    @form = form
    
    subject = I18n.t("subject",:scope => [:mailer, :inquiry, :contact])
    #subject = ('=?ISO-2022-JP?B?' + subject.split(//,1).pack('m').chomp + '?=')
    
    mail(:to => site.email,
#      :subject => subject.tojis.force_encoding(__ENCODING__)) do |format|
      :subject => subject) do |format|        
#        :port => config['port'],
#        :address => config['address'],
#        :domain => config['domain'],
#        :user_name => config['user_name'],
#        :authentication => config['authentication'] )do |format|
      format.text
    end  
  end

  def confirm_email(form, site, to_address)
    p "send to #{to_address}"
    @form = form

    subject = I18n.t("subject",:scope => [:mailer, :inquiry, :confirm])
    #subject = ('=?ISO-2022-JP?B?' + subject.split(//,1).pack('m').chomp + '?=')

    mail(:to => to_address,
#      :subject => subject.tojis.force_encoding(__ENCODING__)) do |format|
      :subject => subject) do |format|        
#        :port => config['port'],
#        :address => config['address'],
#        :domain => config['domain'],
#        :user_name => config['user_name'],
#        :authentication => config['authentication'] )do |format|
      format.text
    end  
  end
  
  
  protected
  
  
end
