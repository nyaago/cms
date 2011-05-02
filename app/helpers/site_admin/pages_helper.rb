# = SiteAdmin::ArticlesHelper
# サイトの記事編集のHelper
module SiteAdmin::PagesHelper
  
  # urlパスを返す.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  #   :page - Page番号.Defaultは1
  #   :sort - ソートカラム.
  #   :direction - ソート方向,'asc'または'desc'.Defaultは,'asc'
  # == options
  # :action => action.デフォルトは,'index'
  def site_pages_path(options = {})
    url_for( :controller => "pages", 
    :action => if options[:action].blank? then 'index' else options[:action] end,
    :page =>  if !params[:page].blank?  then 
                params[:page]  
              else 
                if !options[:article].blank? && !options[:article].offset.blank?
                  options[:article].offset
                else
                  1 
                end
              end,
    :sort => if !options[:sort].blank?  then options[:sort]  else false end,
    :direction => if !options[:sort].blank?  then 
      if !params[:direction].blank? and  params[:direction] == 'asc'
        'desc'
      else
        'asc'
      end
    else 
      'asc'
    end,
    :id => false
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
  def site_page_path(article = false, options = {})
    url_for(:action => if options[:action].blank? then 
              if params[:action] == 'edit' ||  params[:action] == 'update'
                'update'
              elsif params[:action] == 'new' || params[:action] == 'create'
                'create'
              else
                'show' 
              end
            else 
              options[:action] 
            end, 
            :id => if article.nil? then params[:id] else
                      if article.respond_to?(:id) then  article.id else article 
                      end 
                  end,
            :is_history => if article.respond_to?(:article_id) then 1 else  nil end,
            :page => if !params[:page].blank?  then params[:page]  else 1 end,
            :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
            :direction => if !params[:direction].blank?  then params[:direction]  else nil end
              )
  end

  # 新規記事作成Actionのurlパスを返す.
  def new_site_page_path
    site_page_path(false, :action => :new)
  end
  
  def published_human_name(article)
    Category::Published.name_with_bool(article.published)
  end
  
  def layout_image_tag(article, location_type)
    if article.respond_to?("#{location_type}_image_url".to_sym)
      url = article.send("#{location_type}_image_url".to_sym)
      unless url.nil?
        image_tag(url)
      else
        ''
      end
    else
      ''
    end
  end
  
  
end
