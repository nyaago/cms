# = BlogFromPop3
# Pop3からの受信によるブログ投稿
class BlogFromPop3
  
  require 'net/pop'
  require 'mail'
  require 'kconv'
  
  # pop3から受信して投稿(記事モデルへの登録)
  def receive_and_post(site)
    return if site.post_setting.nil? || site.post_setting.pop3_login.nil? 
    site.post_setting.pop3_host.nil? || 
    post_setting = site.post_setting
    connection = Net::POP3.new( post_setting.pop3_host, 
                                if post_setting.pop3_port.blank? ||  post_setting.pop3_port == 0 
                                  110
                                else
                                  post_setting.pop3_port 
                                end
                                )
    if post_setting.pop3_ssl
      connection.enable_ssl
    else
      connection.disable_ssl
    end
    begin
      #p "connecting to #{post_setting.pop3_login}..."
      connection.start(post_setting.pop3_login, post_setting.pop3_password) do |pop|
      #p "connected..."
       begin
          pop.each_mail do |pop_mail|
            mail = Mail.new(pop_mail.pop)
            unless post_setting.from_address.blank? 
              regexp = Regexp.new(post_setting.from_address)
              unless mail.from.size > 0 && regexp.match(mail.from[0].toutf8)
                pop_mail.delete
                p "skip"
                next
              end
            end
            p mail.body.decoded.toutf8
            p mail.subject.toutf8
            BlogArticle.create(:content => hbr(mail.body.decoded.toutf8),
                                :title => mail.subject.toutf8,
                                :published => true,
                                :site => site
                                )
            pop_mail.delete
        end
        rescue => ex
          p ex.message
          p ex.backtrace
          connection.reset
        end
      end
    rescue => ex
      p ex.message
      p ex.backtrace
    end
  end
  
  private
  
  def hbr(str)
     str = ERB::Util.html_escape(str)
     str.gsub(/\r\n|\r|\n/, "<br />")
  end
  
end