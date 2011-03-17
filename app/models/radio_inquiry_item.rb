# = RadioInquiryItem
# 問い合わせの項目 - ラジオボタン
class RadioInquiryItem < ActiveRecord::Base
  
  # サイトとの関連
  has_one   :site_inquiry_item,     :as => :inquiry_item, :dependent => :destroy
  # 変更ユーザ
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  # 生成時にフィルター
  # default 値を設定
  before_create :set_default
  # 保存前のfilter
  # 未入力の選択肢の値があれば、詰めて登録
  before_save :omit_empty_value
  
  protected
  
  # default 値を設定
  # * 初期選択を1つめの選択肢にする.
  def set_default
    unless self.default_index
      self.default_index = 1
    end
  end
  
  # 未入力の選択肢の値があれば、詰めて登録
  def omit_empty_value
    (1..6).each do |i|
      if self.send("value#{i}").blank?
        self.send("value#{i}=", self.send("value#{i+1}"))
        self.send("value#{i+1}=", nil)
        if i < default_index
          self.default_index = self.default_index - 1
        elsif i == default_index
          self.default_index = 1
        end
      end
      
    end
  end
  
end
