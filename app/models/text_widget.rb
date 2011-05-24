# = TextWidget
# テキストWidget
class TextWidget < ActiveRecord::Base
  
  has_one   :site_widget,     :as => :widget, :dependent => :destroy
  belongs_to :user, :readonly => true, :foreign_key => :updated_by

  # 保存前のフィルター
  # 各属性の不要な前後空白をぬく
  before_save :strip_attributes!

  # 各属性の不要な前後空白をぬく
  def strip_attributes!
    !title.nil? && title.strip_with_full_size_space!
    true
  end
  
end
