class Time
  
  p " load time.rb"
  
  class << self


    # utc メソッドのp
#    alias_method :utc_without_trim, :utc 
#  
#    def utc_with_trim(*args)
#    
#      args.each do |v|
#        p "utc args - #{v}"
#      end
#    
#      if args.length >= 3 && args[4] >= 24
#        args[3] = 0
#      end
#      if args.length >= 5 && args[4] >= 60
#        args[4] = 0
#      end
#      if args.length >= 6 && args[5] >= 60
#        args[5] = 0
#      end
#      utc_without_trim(*args)
#    end
  
#    alias_method :utc, :utc_with_trim
  
  end
  
end