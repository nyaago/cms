# = SiteWidget
# サイトとWidgetの対応
class SiteWidget < ActiveRecord::Base
  
  # 
  belongs_to :site
  
  # タイプ別のwidgetへの関連
  belongs_to :widget, :polymorphic => true
  
end
