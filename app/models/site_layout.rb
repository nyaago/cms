class SiteLayout < ActiveRecord::Base
  belongs_to :site
  
  # 作成時のFilter. default値の設定
  before_create :set_default
  
  
  # default値の設定
  def set_default
    self.theme = 'default'
    self.eye_catch_type = 'none'
    self.font_size = 'default'
    self.skin_color = 'default'
    self.column_layout = 'menu_on_left'
    self.global_navigation = 'home_link'
  end
  
end
