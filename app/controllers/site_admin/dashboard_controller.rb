# = SiteAdmin::DashboardController
# dashboard 表示のcontroller
class SiteAdmin::DashboardController < SiteAdmin::BaseController

  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site_admin", "dashboard"].freeze

  # GET /dashboard
  # 
  def index
    flash[:notice] = ''
    @informations = Information.order("updated_at desc")
    @blog_count = @site.blogs.count
    @page_count = @site.pages.count
    @capacity = @site.used_capacity
    @widget_count = @site.site_widgets.count 
    @themes = Layout::Theme.load
    @theme = @themes.find_by_name(@site.site_layout.theme)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @informations }
    end
  end
  
  protected
  
  # ユーザがこのcontroller の機能を使用可能かどうかを返す.
  # userがnilでなければOKにする.
  def accessible_for?(user)
    !!user
  end
  
end
