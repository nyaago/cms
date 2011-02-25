# = SiteSetting
# サイトの一般的な設定
class SiteSetting < ActiveRecord::Base
  
  # サイトへの所属関連
  belongs_to :site

end
