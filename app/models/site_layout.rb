class SiteLayout < ActiveRecord::Base
  belongs_to :site
  
  # 作成時のFilter. default値の設定
  before_create :set_default
  
  
  # default値の設定
  def set_default
    self.theme = 'default'
  end
  
end
