# = Article
# Ariticle(記事)モデル
class Article < ActiveRecord::Base
  
  # 記事タイプ
  TYPE_PAGE = 1
  TYPE_BLOG = 2
  
  
  validates_presence_of :title

  
end
