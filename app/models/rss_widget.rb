# = RssWidget
# Rss Widget
class RssWidget < ActiveRecord::Base
  
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  has_one   :site_widget,     :as => :widget, :dependent => :destroy
  
end
