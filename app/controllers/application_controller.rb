# = ApplicationController
# 公開ページ共通のController
class ApplicationController < ActionController::Base
  protect_from_forgery # :except => :hoge
  
  NEW_BLOGS_MAX = 5
  
  # action実行前フィルター.siteモデルをロード
  # サイトがなければ, 404リダイレクト
  prepend_before_filter :load_site
  
  # actionの前処理
  # 新着blogの配列変数(@new_blogs)を生成
  before_filter         :new_blogs
  
  # actionの前処理
  # Blog Archive選択のための月の一覧を生成
  # 要素として datetime(Datetimeオブジェクト), to_s を属性として含む配列 @blog_monthsが生成される.
  before_filter         :blog_months

  # actionの前処理
  # ページタイトルを格納する変数(@page_title)を生成  
  before_filter          :set_page_title_var
  
  # 表示対象のサイト (Site モデルのレコード)
  attr_reader  :site
    
  #def hello
    # self.allow_forgery_protection = false
  #end
  
  protected 
  
  # siteモデルをロード
  # サイトがなければ, 404リダイレクト
  def load_site
    
    site_name = params[:site]
    @site = nil
    if !site_name.blank?
      @site = Site.find_by_name(site_name)
    end
    if @site.nil?
      respond_to do |format|
         format.html { 
           render :file => "#{::Rails.root.to_s}/public/404.html", 
            :status => :not_found 
          }
         format.xml  { render :status => :not_found }
       end
       return
    end
    @site
    
  end
  
  # 新着blogの配列変数(@new_blogs)を生成
  def new_blogs
    @new_blogs = @site.blogs.where("published = true").
                        order("updated_at desc").
                        limit(@site.view_setting.title_count_in_home)

    
    
  end
  
  # Blog Archive選択のための月の一覧を生成
  # 要素として datetime(Datetimeオブジェクト), to_s を属性として含む配列 @blog_monthsが生成される.
  def blog_months
    @blog_months = BlogArticle.updated_months
  end
  
  # ページタイトルを格納する変数(@page_title)を生成
  def set_page_title_var
    @page_title = self.page_title
  end
  
  # ページタイトルを返す.
  # 各具象controllerで定義することにより、出力するtitleタグへの反映を行う.
  # 返り値のオブジェクトでtitleメソッドが実装されていれば、それを採用.
  # そうでなければ,to_sの値を参照.
  def page_title
    nil
  end
  
end
