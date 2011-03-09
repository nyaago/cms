# = RssWidget
# Rss Widget
class RssWidget < ActiveRecord::Base
  
  has_one   :site_widget,     :as => :widget, :dependent => :destroy
  
end
