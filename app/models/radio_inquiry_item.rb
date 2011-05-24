# = RadioInquiryItem
# 問い合わせの項目 - ラジオボタン
class RadioInquiryItem < ActiveRecord::Base
  # 選択肢の数
  VALUE_COUNT = 7
  
  # サイトとの関連
  has_one   :site_inquiry_item,     :as => :inquiry_item, :dependent => :destroy
  # 変更ユーザ
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  # 生成時にフィルター
  # default 値を設定
  before_create :set_default!
  # 保存前のfilter
  # 未入力の選択肢の値があれば、詰めて登録
  before_update :omit_empty_value!
  # 保存前のフィルター
  # 各属性の不要な前後空白をぬく
  before_save :strip_attributes!
  
  
  # この問い合わせ項目のdefault の値を返す.
  # 値として defaultの選択肢の値を返す
  def default_value
    method = "value#{default_index}".to_sym
    if self.respond_to?(method)
      self.send(method)
    else
      ''
    end
  end

  protected
  
  # default 値を設定
  # * 初期選択を1つめの選択肢にする.
  def set_default!
    unless self.default_index
      self.default_index = 0
    end
  end
  
  # 未入力の選択肢の値があれば、詰めて登録
  def omit_empty_value!
    count = VALUE_COUNT
    (1..(count - 1)).to_a.reverse.each do |i|
      if self.send("value#{i}").blank?
        ((i+1)..count).each do |src_index|
          self.send("value#{src_index - 1}=", self.send("value#{src_index}"))
          self.send("value#{src_index}=", nil)
        end
        if i < default_index
          self.default_index = self.default_index - 1
        elsif i == default_index  # 値がない選択肢がdefaultになっている.
          self.default_index = 1
        end
      end
    end
  end
  
  # 各属性の不要な前後空白をぬく
  def strip_attributes!
    !title.nil? && title.strip_with_full_size_space!
    count = VALUE_COUNT
    (1..count).each do |i|
      if  self.respond_to?("value#{i}") && !self.send("value#{i}").nil?
        value = send("value#{i}")
        self.send("value#{i}=", value.strip_with_full_size_space)
      end
    end
    true
  end
  
end
