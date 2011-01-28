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
  
  # メニュー表示順を１つ後ろになるよう変更.
  # Site内のPage記事全てのmenu_orderをつけなおすことにより行う.
  def to_next_menu_order
    @articles = Article.
            select("id, menu_order").
            where("site_id = :site_id and article_type = :article_type", 
                  :site_id => self.site_id, :article_type => TYPE_PAGE).
                  order('menu_order')

    replace_flag = false

    @articles.each_with_index do |article, i|
      article.menu_order = 
        if article.id == self.id
          replace_flag = true
          if i == @articles.count - 1 then i + 1 else i + 1 + 1 end
        elsif replace_flag 
          replace_flag = false
          i + 1 - 1
        else 
          i + 1
        end
      article.save(:validate => false)
    end
  end

  # メニュー表示順を１つ前になるよう変更.
  # Site内のPage記事全てのmenu_orderをつけなおすことにより行う.
  def to_previous_menu_order
    @articles = Article.
            select("id, menu_order").
            where("site_id = :site_id and article_type = :article_type", 
                  :site_id => self.site_id, :article_type => TYPE_PAGE).
                  order('menu_order desc')
                  
    replace_flag = false

    @articles.each_with_index do |article, i|
      p = @articles.count  - i
      article.menu_order = 
        if article.id == self.id
          replace_flag = true
          if p  == 1 then p else p - 1  end
        elsif replace_flag 
          replace_flag = false
          p + 1
        else 
          p
        end
      article.save(:validate => false)
    end
  end

  # 公開/非公開のselectタブで表示するソースとなるMap(Hash)を返す
  # Key が表示名,Valueがモデルへの登録値となる.
  def self.map_for_published_selection
    Category::Published.map_for_selection
  end
  
end
