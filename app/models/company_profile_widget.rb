# = CompanyProfileWidget
#  会社プロフィールWidget
class CompanyProfileWidget < ActiveRecord::Base

  require 'email_validator' 
  require 'http_url_validator' 

  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  has_one   :site_widget,     :as => :widget, :dependent => :destroy

  validates :email, :email => true
  validates :link_url1, :http_url => true
  validates :link_url2, :http_url => true

end
