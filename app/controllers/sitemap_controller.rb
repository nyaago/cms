# = SitemapController
# サイトマップ出力
class SitemapController < ActionController::Base
  
  def index
    @articles = []
    Site.select("id, name").where('canceled = false').
                        where('suspended = false').
                        where('published = true').
                        each do |site|
      @articles += site.articles.where("published = true")

    end
    respond_to do |format|
      format.xml do 
        render :layout => false
      end
    end
  end
  
end
