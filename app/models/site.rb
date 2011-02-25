# = Site
# サイト基本情報のモデル
class Site < ActiveRecord::Base
 
# email の validator を読み込む
require 'email_validator' 
  
  # 作成時のFilter. default値の設定
  before_create :set_default
  # 作成時のFilter. 依存する子のモデルを生成
  after_create  :create_dependance
  # 更新前のFilter. (存在しなければ)依存する子のモデルを生成
  after_update  :create_dependance


  # validator
  validates :email, :email => true
  validates_presence_of :name
  validates_presence_of :title

  #
  has_many  :articles, :dependent => :destroy
  has_many  :pages, 
            :class_name => 'Article', 
            :conditions => "article_type = #{Article::TYPE_PAGE}"
  has_many  :users, :dependent => :destroy
  has_one   :site_layout,   :dependent => :destroy
  has_one   :site_setting,  :dependent => :destroy
  has_one   :search_engine_optimization,  :dependent => :destroy
  has_one   :post_setting,  :dependent => :destroy
  has_one   :view_setting,  :dependent => :destroy
  has_many  :images
  has_many  :layout_images


  
  protected
  
  # default値の設定
  def set_default
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
