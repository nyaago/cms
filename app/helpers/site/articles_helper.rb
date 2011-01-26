# = Site::ArticlesHelper
# サイトの記事編集のHelper
module Site::ArticlesHelper
  
  # urlパスを返す.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  #   :page - Page番号.Defaultは1
  #   :sort - ソートカラム.
  #   :direction - ソート方向,'asc'または'desc'.Defaultは,'asc'
  # == options
  # :action => action.デフォルトは,'index'
  def site_articles_path(options = {})
    url_for( :controller => "articles", 
    :action => if options[:action].blank? then 'index' else options[:action] end,
    :page => if !params[:page].blank?  then params[:page]  else 1 end,
    :sort => if !options[:sort].blank?  then options[:page]  else nil end,
    :direction => if !options[:sort].blank?  then 
      if !params[:direction].blank? and  params[:direction] == 'asc'
        'desc'
      else
        'asc'
      end
    else 
      'asc'
    end
     )
  end

  # 指定記事に対するurlパスを返す.
  # 記事(Article)は,Articleモデルまたは、id値.nil指定で省略.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  #   :page - Page番号.Defaultは1
  #   :sort - ソートカラム.
  #   :direction - ソート方向,'asc'または'desc'.Defaultは,'asc'
  # == options
  # :action => action.デフォルトは,'show'
  def site_article_path(article = nil, options = {})
    url_for(:action => if options[:action].blank? then 
              if params[:action] == 'edit'
                'update'
              elsif params[:action] == 'new'
                'create'
              else
                'show' 
              end
            else 
              options[:action] 
            end, 
            :id => if article.nil? then params[:id] else
              if article.respond_to?(:id) then  article.id else article end 
            end,
            :page => if !params[:page].blank?  then params[:page]  else 1 end,
            :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
            :direction => if !params[:direction].blank?  then params[:direction]  else nil end,
              )
  end

  # 新規記事作成Actionのurlパスを返す.
  def new_site_article_path
    site_article_path(:nil, :action => :new)
  end
  
  # 指定したidの見出しレベル表示名を返す.
  # idは1〜3の値を指定.
  def heading_level_name_with_id(id)
    Category::HeadingLevel.name_with_id(id)
  end


end
