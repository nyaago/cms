# = BlogsController
# Blog記事表示
class BlogsController < ApplicationController

  # 記事一覧の１ページの件数
  PER_PAGR = 3

  # GET /blogs/show/1
  # GET /blogs/shouw/1.xml
  # 指定されたidの記事を表示
  def show
    @article = @site.blogs.where("id = :id and published = true", 
                                  :id => params[:id]).first

    if @article.nil?
      respond_to do |format|
         format.html { 
           render :file => "#{::Rails.root.to_s}/app/views/404.html.erb", 
            :status => :not_found 
          }
         format.xml  { render :status => :not_found }
       end
       return
    end

    respond_to do |format|
      format.html do
        render :layout =>  @site.site_layout.theme_layout_path_for_rendering
      end
      format.xml  { render :xml => @article }
    end
  end
  
  # GET /blogs/month/1
  # GET /blogs/month/1.xml
  # 指定月のblog記事一覧.
  # == リクエストパラメータ 
  # * :month  - <yyyymm>書式の年月
  def month
    cur_month = if params[:month] then params[:month] else nil end
    begin 
      @articles = @site.blogs.where("published = true").
                          filter_by_updated_month(cur_month).
                          order("updated_at desc").
                          paginate(
                                :page => 
                                  if !params[:page].blank? && params[:page].to_i >= 1 
                                    params[:page].to_i
                                  else 
                                    1 
                                  end, 
                                :per_page => 
                                unless @site.view_setting.nil? 
                                  @site.view_setting.article_count_per_page
                                else
                                  PER_PAGE
                                end )

      @month = Time.new(cur_month[0..3], cur_month[4..5])
    rescue
      respond_to do |format|
         format.html { 
           render :file => "#{::Rails.root.to_s}/app/views/404.html.erb", 
            :status => :not_found 
          }
         format.xml  { render :status => :not_found }
       end
       return
    end
    if @month.nil?
      respond_to do |format|
         format.html { 
           render :file => "#{::Rails.root.to_s}/app/views/404.html.erb", 
            :status => :not_found 
          }
         format.xml  { render :status => :not_found }
       end
       return
    end
    
    respond_to do |format|
      format.html do
        render :layout =>  @site.site_layout.theme_layout_path_for_rendering
      end

      format.xml  { render :xml => @articles }
    end
    
  end
  
  protected 
  
  # ページタイトルを返す.
  # 月がパラメータとしてわたされた場合,その月を文字列値をタイトルとして返す.
  # それ以外は、defaultの動作(Articleのtitleをタイトルとする)となるよう、nilを返す.
  def page_title
    unless params[:month].blank?
      begin
        month = Time.new(params[:month][0..3], params[:month][4..5])
        I18n.localize(month, :format => :default, :scope => [:month])
      rescue
        nil
      end
    else
      nil     # default の挙動
    end
  end

end

