# = ApplicationController
#
class ApplicationController < ActionController::Base
  protect_from_forgery # :except => :hoge
  
  #def hello
    # self.allow_forgery_protection = false
  #end
end
