# = Article
# Ariticle(記事)モデル
class Article < ActiveRecord::Base

  # 保存前のcallback
  # 記事ががhome(top)ページに指定された場合,他の記事のhome設定を解除
  before_save :cancel_is_home_except_self

  # 保存前のcallback
  # 公開開始日時が将来に設定されている場合、公開状態をoffにする
  before_save :check_published
  
  # 新規作成前のcallback
  # menu order をサイトでの最大値とする
  before_create :set_max_menu_order
  
  TRANSLATION_SCOPE = [:errors, :messages]
  
  # 記事タイプ
  TYPE_PAGE = 1
  TYPE_BLOG = 2
  

  belongs_to :site, :readonly => true
  belongs_to :user, :readonly => true
  has_many   :article_histories
    
  validates_presence_of :title

  
  # 名前が半角小文字英時であるかのvalidation
  validates_format_of   :name, :with => /^[a-z]*$/, 
                        :message => I18n.t(:only_lower_alpha, 
                                            :scope => TRANSLATION_SCOPE)
  # 名前がサイト内でUniquであるのValidation  
  validates_with Validator::Article::NameUniqueness
  # 公開ページ記事数制限のValidation
  validates_with Validator::Article::PageLimit
  
  
  # 記事モデルに対する公開状態の表示名を返す.
  def published_name
    Category::Published.name_with_bool(self.published)
  end
  
  # 記事モデルに対するトップ（ホーム）ページ状態の表示名を返す.
  def is_home_name
    Category::IsHome.name_with_bool(self.is_home)
  end
  

  # 公開/非公開のselectタブで表示するソースとなるMap(Hash)を返す
  # Key が表示名,Valueがモデルへの登録値となる.
  def self.map_for_published_selection
    Category::Published.map_for_selection
  end

  protected
  
  # 記事ががhome(top)ページに指定された場合,他の記事のhome設定を解除
  def cancel_is_home_except_self
    return if !self.respond_to?(:is_home)
    
    begin
      return if !self.is_home

      Article.select("id, is_home").
              where("site_id = :site_id and is_home = true" +
                    " and id <> :id",
                    :site_id => self.site_id, :id => self.id).each do |article|
        article.is_home = false
        article.save!(:validate => false)
      end
    rescue ActiveModel::MissingAttributeError => ex
      # is_home 属性が選択されていない場合の例外なので無視
    end
  end

  # menu order をサイトでの最大値とする
  def set_max_menu_order
    max_article = Article.select('max(menu_order) as max_order').
                          where('site_id = :site_id', 
                                :site_id => self.site.id).
                          first
    self.menu_order = 
      if max_article.nil? || max_article.max_order.nil? 
        1 
      else 
        max_article.max_order + 1 
      end
    
  end
  
  # 公開開始日時が将来に設定されている場合、公開状態をoffにする
  def check_published
    unless published_from.nil?
      if Time.now < published_from
        self.published = nil
      end
    end
  end
    
end
