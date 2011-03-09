# = CompanyProfileWidget
#  会社プロフィールWidget
class CompanyProfileWidget < ActiveRecord::Base

  require 'email_validator' 
  require 'http_url_validator' 

  has_one   :site_widget,     :as => :widget, :dependent => :destroy

  validates :email, :email => true
  validates :link_url1, :http_url => true
  validates :link_url2, :http_url => true

end
