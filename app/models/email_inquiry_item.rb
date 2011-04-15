# = EmailInquiryItem
# 問い合わせ項目 - EMail アドレス
class EmailInquiryItem < ActiveRecord::Base
  
  # サイトとの関連
  has_one   :site_inquiry_item,     :as => :inquiry_item, :dependent => :destroy
  # 変更ユーザ
  belongs_to :user, :readonly => true, :foreign_key => :updated_by

  # 保存前のフィルター
  # 各属性の不要な前後空白をぬく
  before_save :strip_attributes

  # 各属性の不要な前後空白をぬく
  def strip_attributes
    !title.nil? && title.strip_with_full_size_space!
    true
  end
  
end
