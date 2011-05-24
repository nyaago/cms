# = SiteSetting
# サイトの一般的な設定
class SiteSetting < ActiveRecord::Base

  # 作成時のFilter. default値の設定
  before_create :set_default!
  
  # サイトへの所属関連
  belongs_to :site
  belongs_to :user, :readonly => true, :foreign_key => :updated_by

  protected
  
  # default値の設定
  def set_default!
    self.date_format = '%Y/%m/%d'
    self.time_format = "%H:%M"
  end


end
