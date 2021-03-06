# = SearchEngineOptimization 
# SEO設定のモデル
class SearchEngineOptimization < ActiveRecord::Base
  
  # 変数置換に関するmodule
  include Category::ReplacedVariable
  
  belongs_to :site
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  
  # record生成時のfilter.
  # default値の設定を行う.
  before_create :set_default!
  
  # 保存前のフィルター
  # 各属性の不要な前後空白をぬく
  before_save :strip_attributes!

  
  # フォーマット属性より、ページ記事のタイトルに表示する値を得る
  # self::REPLACE_MAP_FOR_ARTICLEで定義されている置換変数を引数の記事のタイトルに置換
  # self::REPLACE_MAP_FOR_SITEで定義されている置換変数を引数のサイトのタイトルに置換
  # == params
  # * article - 記事オブジェクト, title属性,それがなければto_sの値を参照
  # == see
  # * Category::ReplacedVariable
  def page_title_text(article, site)
    s = self.page_title_format
    s = replace_string_with_mapping(s, article, map_for_article)
    s = replace_string_with_mapping(s, site, map_for_site)
  end
  
  # フォーマット属性より、blog記事のタイトルに表示する値を得る
  # self::REPLACE_MAP_FOR_ARTICLEで定義されている置換変数を引数の記事のタイトルに置換
  # self::REPLACE_MAP_FOR_SITEで定義されている置換変数を引数のサイトのタイトルに置換
  # == params
  # * article - 記事オブジェクト, title属性,それがなければto_sの値を参照
  # == see
  # * Category::ReplacedVariable
  def blog_title_text(article, site)
    s = self.blog_title_format
    s = replace_string_with_mapping(s, article, map_for_article)
    s = replace_string_with_mapping(s, site, map_for_site)
  end
  
  # フォーマット属性より、404ページのタイトルに表示する値を得る
  # self::URL_REPLACE_MAP_FOR_REQUESTで定義されている置換変数を引数のrequestオブジェクトのurlに置換
  # == params
  # * request - requestオブジェクト
  # == see
  # * Category::ReplacedVariable
  def not_found_title_text(request)
    replace_string_with_mapping(self.not_found_title_format, request, 
                                map_for_request)
  end
  
  
  
  protected

  # default値の設定
  def set_default!
    self.page_title_format = "#{self.class::REPLACE_MAP_FOR_ARTICLE.to_a[0][0]} | " + 
                              "#{self.class::REPLACE_MAP_FOR_SITE.to_a[0][0]}"
    self.blog_title_format = "#{self.class::REPLACE_MAP_FOR_ARTICLE.to_a[0][0]} | " + 
                              "#{self.class::REPLACE_MAP_FOR_SITE.to_a[0][0]}"
    self.archive_title_format = "#{self.class::REPLACE_MAP_FOR_ARTICLE.to_a[0][0]} | " + 
                              "#{self.class::REPLACE_MAP_FOR_SITE.to_a[0][0]}"
    self.not_found_title_format = "#{self.class::URL_REPLACE_MAP_FOR_REQUEST.to_a[0][0]} " +
                              "not found"
    self
  end
  
  # 各属性の不要な前後空白をぬく
  def strip_attributes!
    !page_keywords.nil? && page_keywords.strip_with_full_size_space!
    !blog_keywords.nil? && blog_keywords.strip_with_full_size_space!
    !page_description.nil? && page_description.strip_with_full_size_space!
    !blog_description.nil? && blog_description.strip_with_full_size_space!
    true
  end
  
  

  
end
