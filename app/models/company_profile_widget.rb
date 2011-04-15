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
  
  # 保存前のフィルター
  # 各属性の不要な前後空白をぬく
  before_save :strip_attributes

  # 各属性の不要な前後空白をぬく
  def strip_attributes
    !name.nil? && name.strip_with_full_size_space!
    !address.nil? && address.strip_with_full_size_space!
    !zip_code.nil? && zip_code.strip_with_full_size_space!
    !tel_no.nil? && tel_no.strip_with_full_size_space!
    !link_url1.nil? && link_url1.strip_with_full_size_space!
    !link_title1.nil? && link_title1.strip_with_full_size_space!
    !link_url2.nil? && link_url2.strip_with_full_size_space!
    !link_title2.nil? && link_title2.strip_with_full_size_space!
    true
  end
  

end
