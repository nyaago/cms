class Site < ActiveRecord::Base
  
  # 作成時のFilter. default値の設定
  before_create :set_default
  
  has_many :articles, :dependent => :destroy
  has_many :users, :dependent => :destroy
  
  protected
  
  # default値の設定
  def set_default
    self.template = 'default'
    self.theme = 'default'
  end
  
end
