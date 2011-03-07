# = TextWidget
# テキストWidget
class TextWidget < ActiveRecord::Base
  
  has_one   :site_widget,     :as => :widget
  
end
