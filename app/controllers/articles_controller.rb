class ArticlesController < ApplicationController

  helper :all  
  # GET /articles.atom
  # GET /articles.rss
  # 記事一覧の表示
  def index
    @articles = @site.articles.where("published = true").
                        order("updated_at desc").
                        limit(@site.view_setting.article_count_of_rss)

    #p "total -- " + @articles.total_entries.to_s
    respond_to do |format|
      format.html # index.html.erb
      format.rss  
      format.atom { render :action => "atom"}
    end
  end
  
end
