class Time
  
  p " load time.rb"
  
  class << self

    
    # utc メソッドのpatch
    alias_method :utc_without_trim, :utc 
  
    def utc_with_trim(*args)
    
      if args.length >= 6
        args[5] = 0
      end
      utc_without_trim(*args)
    end
  
    alias_method :utc, :utc_with_trim
  
  end
  
end