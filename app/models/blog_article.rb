# = BlogArticle
# Blog記事のモデル.
# 記事(Article)モデルからの継承
class BlogArticle < Article

  # 年月を保持するオブジェクト
  class Month
    
    attr_reader :year, :month
    
    def initialize(year, month)
      @year = year
      @month = month
      @datetime = DateTime.new(year, month)
    end
    
    def to_s(format = nil)
      @datetime.strftime(format)
    end
    
    def datetime
      @datetime
    end
    
  end
  
  # 年月での絞り込み
  def self.filter_by_created_month(cur_month, site_id = nil)
    return where(nil)  if cur_month.blank?
    where("  DATE_FORMAT(created_at, '%Y%m') = :ym" ,
          :ym =>    cur_month
          )
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

end
