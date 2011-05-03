# 設定されているpop3アカウントからの投稿.
# crontab 設定例 =>
# */2 * * * * <home>/.rvm/gems/ruby-1.9.2-p136/bin/rails runner <app>/runners/runner_for_posting_from_pop3.rb
Site.all.each do |site|

  begin 
    BlogFromPop3.new.receive_and_post(site)
  rescue => ex
    p ex.message
    p ex.backtrace
    p "error site = #{site.name}"
  end
  
end