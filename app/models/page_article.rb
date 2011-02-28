# = PageArticle
# ページ記事のモデル.
# 記事(Article)モデルからの継承
class PageArticle < Article

  has_many   :page_article_histories

  # メニュー表示順を１つ後ろになるよう変更.
  # Site内のPage記事全てのmenu_orderをつけなおすことにより行う.
  def to_next_menu_order
    articles = self.class.
            select("id, menu_order").
            where("site_id = :site_id", 
                  :site_id => self.site_id).
                  order('menu_order')

    replace_flag = false

    articles.each_with_index do |article, i|
      article.menu_order = 
        if article.id == self.id
          replace_flag = true
          if i == articles.count - 1 then i + 1 else i + 1 + 1 end
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
    articles = self.class.
            select("id, menu_order").
            where("site_id = :site_id", 
                  :site_id => self.site_id).
                  order('menu_order desc')
                  
    replace_flag = false

    articles.each_with_index do |article, i|
      p = articles.count  - i
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
  

end
