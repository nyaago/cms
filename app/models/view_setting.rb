# = ViewSetting
# 表示設定
class ViewSetting < ActiveRecord::Base
  
  # 新規作成前のフィルター.default 値の設定.
  before_create :set_default
  
  # サイトへの所属関連
  belongs_to :site
  
  # validates
  validates_numericality_of :title_count_in_home, 
                            :greater_than  => 0,
                            :less_than_or_equal_to => 10
  validates_numericality_of :article_count_per_page, 
                            :greater_than  => 0,
                            :less_than_or_equal_to => 10
  validates_numericality_of :article_count_of_rss, 
                            :greater_than  => 0,
                            :less_than_or_equal_to => 20
  
  protected
  
  # default 値の設定.
  def set_default
    self.title_count_in_home = 5
    self.article_count_per_page = 5
    self.rss_type = "rss2"
    self.article_count_of_rss = 10
    self.view_whole_in_rss = false
  end
  
end
