# = CheckboxInquiryItem
# 問い合わせ項目 - チェックボックス 
class CheckboxInquiryItem < ActiveRecord::Base
  
  # サイトとの関連
  has_one   :site_inquiry_item,     :as => :inquiry_item, :dependent => :destroy
  # 変更ユーザ
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  
end
