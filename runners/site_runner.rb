Site.all.each do |site|

  begin 
    BlogFromPop3.new.receive_and_post(site)
  rescue => ex
    p ex.message
    p ex.backtrace
    p "error site = #{site.name}"
  end
  
end