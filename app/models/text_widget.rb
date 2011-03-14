# = TextWidget
# テキストWidget
class TextWidget < ActiveRecord::Base
  
  has_one   :site_widget,     :as => :widget, :dependent => :destroy
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  
end
