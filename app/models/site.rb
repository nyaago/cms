# = Site
# サイト基本情報のモデル
class Site < ActiveRecord::Base

# email の validator を読み込む
require 'email_validator' 

  include Figure::Site::Capacity

  # 作成時のFilter. default値の設定
  before_create :set_default
  # 作成時のFilter. 依存する子のモデルを生成
  after_create  :create_dependance
  # 更新後のFilter. (存在しなければ)依存する子のモデルを生成
  after_update  :create_dependance
  # 更新前のFilter. cancel予約されている日時が過ぎていれば, cancelする.
  #before_update :cancel_if_reserved_before
  # 更新前のFilter . cancelされたなら、cancel日時を設定
  before_update :set_canceled_at_if_canceled

  # validator
  validates_presence_of :email
  validates :email, :email => true
  validates_presence_of :name
  validates_with Validator::Alphanumeric, :attribute => :name
  validates_with Validator::Site::ReservedName
  validates_with Validator::Site::CancellationReservedFuture
  validates_presence_of :title
  validates_uniqueness_of :name
  validates_numericality_of :max_mbyte, 
                            :only_integer => true,
                            :less_than_or_equal_to => 1000,
                            :greater_than_or_equal_to => 1

  # ユーザとの関連
  has_many  :users, :dependent => :destroy

  # 記事、画像との関連
  has_many  :articles, :dependent => :destroy,
              :conditions => "is_temporary is null or is_temporary = false"
  has_many  :pages, 
            :class_name => 'PageArticle',
            :conditions => "is_temporary is null or is_temporary = false"
  has_many  :blogs, 
            :class_name => 'BlogArticle',
            :conditions => "is_temporary is null or is_temporary = false"
  has_many  :images

  # レイアウト、設定関連
  has_one   :site_layout,   :dependent => :destroy
  has_one   :site_setting,  :dependent => :destroy
  has_one   :search_engine_optimization,  :dependent => :destroy
  has_one   :post_setting,  :dependent => :destroy
  has_one   :view_setting,  :dependent => :destroy
  has_many  :layout_images
  belongs_to :user, :readonly => true, :foreign_key => :updated_by

  # widget関係
  has_many  :site_widgets
  Layout::Widget.load.each do |widget|
    has_many  widget.name.pluralize.to_sym, :through => :site_widgets,
              :source => :widget, :source_type => widget.class_name,
              :dependent => :destroy
  end
  
  has_many :site_inquiry_items
  Layout::InquiryItem.load.each do |item|
    has_many  item.name.pluralize.to_sym, :through => :site_inquiry_items,
              :source => :inquiry_item, :source_type => item.class_name,
              :dependent => :destroy
  end
  
  # cancel予約されている日時が過ぎていれば, cancelする.
  # ここでは、属性変更だけで、永続化はしない
  def cancel_if_reserved_before
    return false if cancellation_reserved_at.nil?
    return false if canceled
    if cancellation_reserved_at < Time.now
      self.canceled = true
      return true
    else
      return false
    end
  end
  
  # recordを１行のcsvに変換
  def to_csv
    CSV.generate do |csv|
      csv << [self.id, self.name, self.title, self.email,
        if self.published then "yes" else "no" end,
        if self.suspended then "yes" else "no" end,
        if self.canceled  then "yes" else "no" end,
        I18n.l(self.created_at, :format => :long),
        I18n.l(self.updated_at, :format => :long) ]
    end
  end
  
  # 属性名のcsvを返す
  def self.attributes_csv
    attribute_names = ["id", "name", "title", "email", 
        "published", "suspended", "canceled", 
        "created_at", "updated_at"].collect do |attribute|
        Site.human_attribute_name(attribute)
    end
    CSV.generate do |csv|
      csv << attribute_names
    end
  end
  
  # レコード配列のcsvを返す
  def self.generate_csv(records)
    s = self.attributes_csv
    records.each do |record|
      s << record.to_csv
    end
    s
  end
  
  protected
  
  # default値の設定
  def set_default
  end
  
  # cancelされたなら、cancel日時を設定
  def set_canceled_at_if_canceled
    if self.canceled_at.nil? && self.canceled
      self.canceled_at = Time.now
    end
  end
  
  # 依存する子のモデルを生成
  def create_dependance
    layout = SiteLayout.create!(:site => self) if self.site_layout.nil?
    setting = SiteSetting.create!(:site => self) if self.site_setting.nil?
    optimization = SearchEngineOptimization.create!(:site => self) if self.search_engine_optimization.nil?
    post_setting = PostSetting.create!(:site => self) if self.post_setting.nil?
    if self.view_setting.nil?
      v = ViewSetting.create(:site => self)   # ここが、エラーになる場合がある.. TODO 調査
      v.save!
    end
  end
  
end
