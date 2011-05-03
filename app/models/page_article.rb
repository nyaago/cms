# = PageArticle
# ページ記事のモデル.
# 記事(Article)モデルからの継承
class PageArticle < Article

  validates_presence_of :name

  # 新規作成前のcallback
  # menu order をサイトでの最大値とする
  before_create :set_max_menu_order
  
  has_many   :page_article_histories

  # メニュー表示順を１つ後ろになるよう変更.
  # Site内のPage記事全てのmenu_orderをつけなおすことにより行う.
  def to_next_menu_order
    begin
      articles = self.class.
              select("*").
              where("site_id = :site_id", 
                    :site_id => self.site_id).
              where("is_temporary <> true or is_temporary is null").
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
          PageArticle.record_timestamps = false
          article.save(:validate => false)
          PageArticle.record_timestamps = true
      end
    rescue => ex
      PageArticle.record_timestamps = true
      raise ex
    end
  end

  # メニュー表示順を１つ前になるよう変更.
  # Site内のPage記事全てのmenu_orderをつけなおすことにより行う.
  def to_previous_menu_order
    begin
      articles = self.class.
              select("*").
              where("site_id = :site_id", 
                    :site_id => self.site_id).
              where("is_temporary <> true or is_temporary is null").
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
        PageArticle.record_timestamps = false
        article.save(:validate => false)
        PageArticle.record_timestamps = true
      end
    rescue => ex
      PageArticle.record_timestamps = true
      raise ex
    end
  end
  
  # 年月での絞り込み
  def self.filter_by_created_month(cur_month, site_id = nil)
    return where(nil)  if cur_month.blank?
    where("  DATE_FORMAT(created_at, '%Y%m') = :ym" ,
          :ym =>    cur_month
          )
  end
  
  # 年月を保持するオブジェクト
  class Month
    
    attr_reader :year, :month
    
    def initialize(year, month)
      @year = year
      @month = month
      @datetime = DateTime.new(year, month)
    end
    
    def to_s(format = '%Y-%m')
      @datetime.strftime(format)
    end
    
    def ==(other)
      self.class == other.class && self.year == other.year && self.month == other.month
    end
    
    def eql?(other)
      self == other
    end
    
  end
  
  
  # 存在する作成年月の一覧を返す
  # == Parameter
  # * site_id - site id.nilだだと全て
  # * direction - ソート方向(desc/asc).defaultはdesc
  def self.created_months(site_id = nil, direction = 'desc')
    months = select("DATE_FORMAT(created_at, '%Y%m') as ym").
              where(if site_id then 'site_id = :site_id' else nil end,
              :site_id => site_id ).
              where("is_temporary <> true or is_temporary is null").
              group('ym').
              order("ym #{direction}")
    result = []
    months.each do |month|
      elem = Month.new(month.ym[0..3].to_i, month.ym[4..5].to_i)
      result << elem
    end
    result
  end
  

  # 年月での絞り込み
  def self.filter_by_updated_month(cur_month, site_id = nil)
    return where(nil)  if cur_month.blank?
    where("  DATE_FORMAT(updated_at, '%Y%m') = :ym" ,
                  :ym =>    cur_month
                  )
  end
  
  # 存在する作成年月の一覧を返す
  # == Parameter
  # * site_id - site id.nilだだと全て
  # * direction - ソート方向(desc/asc).defaultはdesc
  def self.updated_months(site_id = nil, direction = 'desc')
    months = select("DATE_FORMAT(updated_at, '%Y%m') as ym").
                    where(if site_id then 'site_id = :site_id' else nil end,
                    :site_id => site_id ).
                    where("is_temporary <> true or is_temporary is null").
                    group('ym').
                    order("ym #{direction}")
    result = []
    months.each do |month|
      elem = Month.new(month.ym[0..3].to_i, month.ym[4..5].to_i)
      result << elem
    end
    result
  end
  
  protected
  
  # menu order をサイトでの最大値とする
  def set_max_menu_order
    max_article = self.site.pages.select('max(menu_order) as max_order').
                          first
    self.menu_order = 
      if max_article.nil? || max_article.max_order.nil? 
        1 
      else 
        max_article.max_order + 1 
      end
    true
  end
  

end
