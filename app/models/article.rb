# = Article
# Ariticle(記事)モデル
class Article < ActiveRecord::Base

  require "nokogiri"

  # 保存前のcallback
  # 記事ががhome(top)ページに指定された場合,他の記事のhome設定を解除
  after_save :cancel_is_home_except_self

  # 保存前のcallback
  # 公開開始日時が将来に設定されている場合、公開状態をoffにする
  before_save :check_published
  
  # 新規作成前のcallback
  # menu order をサイトでの最大値とする
  before_create :set_max_menu_order
  
  # 保存前のcallback
  # 各属性の不要な前後空白をぬく
  before_save :strip_attributes

  # 更新前のFilter
  # 公開予約日が過ぎていれば, 公開Onにする
  # before_update :published_if_require_before
  
  TRANSLATION_SCOPE = [:errors, :messages]
  
  # 記事タイプ
  TYPE_PAGE = 1
  TYPE_BLOG = 2
  

  belongs_to :site, :readonly => true
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
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
  
  # 記事内容をテキストにする
  def content_text
    if content
      Nokogiri::HTML(content).text
    else
      ''
    end
  end
  
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

  # 公開予約日が過ぎていれば, 公開する
  def published_if_require_before
    return false if published_from.nil?
    return false if published
    if published_from < Time.now
      self.published = true
      return true
    else
      return false
    end
  end
  
  # 更新日時が1日以上前のtemporary record を削除
  def self.remove_temporaries
    Article.where("is_temporary = true").
            where("updated_at < :yesterday", :yesterday => Time.now.yesterday).
            each do |article|
      article.destroy
      # p "delete temprary id = #{article.id}"
    end
  end

  protected
  
  # 記事ががhome(top)ページに指定された場合,他の記事のhome設定を解除
  def cancel_is_home_except_self
    return true if !self.respond_to?(:is_home)
    
    begin
      return true if !self.is_home

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
    true
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
    true
  end
  
  # 公開開始日時が将来に設定されている場合、公開状態をoffにする
  def check_published
    unless published_from.nil?
      if Time.now < published_from
        self.published = nil
      end
    end
    true
  end

  # 各属性の不要な前後空白をぬく
  def strip_attributes
    begin
      if self.respond_to?(:name) 
        name.strip_with_full_size_space! unless name.nil?
      end
    rescue
    end
    begin
      if self.respond_to?(:title) 
        title.strip_with_full_size_space! unless title.nil?  
      end
    rescue
    end
    begin
      if self.respond_to?(:meta_description) 
        meta_description.strip_with_full_size_space! unless meta_description.nil? 
      end
    rescue
    end
    begin
      if self.respond_to?(:meta_keywords) 
        meta_keywords.strip_with_full_size_space! unless meta_keywords.nil?
      end
    rescue
    end
    true
  end
    
end
