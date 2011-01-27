# = Article
# Ariticle(記事)モデル
class Article < ActiveRecord::Base
  
  # 記事タイプ
  TYPE_PAGE = 1
  TYPE_BLOG = 2
  

  belongs_to :site, :readonly => true
  belongs_to :user, :readonly => true
    
  validates_presence_of :title
  
  
  # 記事モデルに対する公開状態の表示名を返す.
  def published_name
    Category::Published.name_with_bool(self.published)
  end
  
  # 記事モデルに対するトップ（ホーム）ページ状態の表示名を返す.
  def is_home_name
    Category::IsHome.name_with_bool(self.is_home)
  end
  
  def self.map_for_published_selection
    Category::Published.map_for_selection
  end
  
end
