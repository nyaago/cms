# = ApplicationController
# 公開ページ共通のController
class ApplicationController < ActionController::Base
  protect_from_forgery # :except => :hoge

  # action  の after filter. 
  # flash のクリア
  after_filter :clear_flash
  
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

  # actionの前処理
  # sideのwidgetを格納する配列変数(@side_widgets)を生成  
  before_filter          :side_widgets
  
  # actionの前処理
  # footerのwidgetを格納する配列変数(@side_widgets)を生成  
  before_filter          :footer_widgets
  

  
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
    if @site.nil? || !@site.published || @site.suspended || @site.canceled
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
    @blog_months = BlogArticle.updated_months(@site)
  end
  
  # ページタイトルを格納する変数(@page_title)を生成
  def set_page_title_var
    @page_title = self.page_title
  end
  
  # sideのwidgetを格納する配列変数(@side_widgets)を生成  
  def side_widgets
    @side_widgets = []
    site_widgets = @site.site_widgets.
                                      where("area = :area", :area => 'side').
                                      order('position').each do |site_widget|
      unless site_widget.widget.nil?
        @side_widgets << site_widget.widget
      end
    end
    @side_widgets
  end

  # footerのwidgetを格納する配列変数(@side_widgets)を生成  
  def footer_widgets
    @footer_widgets = []
    site_widgets = @site.site_widgets.
                                      where("area = :area", :area => 'footer').
                                      order('position').each do |site_widget|
      unless site_widget.widget.nil?
        @footer_widgets << site_widget.widget
      end
    end
    @footer_widgets
  end
  
  # ページタイトルを返す.
  # 各具象controllerで定義することにより、出力するtitleタグへの反映を行う.
  # 返り値のオブジェクトでtitleメソッドが実装されていれば、それを採用.
  # そうでなければ,to_sの値を参照.
  def page_title
    nil
  end

  # flash のクリア
  def clear_flash
   flash[:notice]=nil
   flash[:error]=nil
   flash[:worn]=nil
  end
  
end
