class Site < ActiveRecord::Base
  
  # 作成時のFilter. default値の設定
  before_create :set_default
  # 作成時のFilter. 依存する子のモデルを生成
  after_create  :create_dependance
  
  has_many  :articles, :dependent => :destroy
  has_many  :pages, 
            :class_name => 'Article', 
            :conditions => "article_type = #{Article::TYPE_PAGE}"
  has_many  :users, :dependent => :destroy
  has_one   :site_layout,  :dependent => :destroy
  has_many  :images
  has_many  :layout_images
  
  protected
  
  # default値の設定
  def set_default
  end
  
  # 依存する子のモデルを生成
  def create_dependance
    layout = SiteLayout.create(:site => self)
  end
  
end
