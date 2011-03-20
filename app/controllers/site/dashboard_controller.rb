# = Site::DashboardController
# dashboard 表示のcontroller
class Site::DashboardController < Site::BaseController

  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "dashboard"].freeze

  # GET /dashboard
  # 
  def index
    flash[:notice] = ''
    @informations = Information.order("updated_at desc")
    @blog_count = @site.blogs.count
    @page_count = @site.pages.count
    @capacity = @site.images.sum("total_size")
    @widget_count = @site.site_widgets.count 
    @theme = @site.site_layout.theme
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @informations }
    end
  end
end
