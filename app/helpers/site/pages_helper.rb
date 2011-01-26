# = Site::PagesHelper
# サイトのページ編集のHelper
module Site::PagesHelper

  TRANSLATION_SCOPE = [:activerecord, :attributes, :page].freeze
  
  # urlパスを返す.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  #   :sort - ソートカラム.
  #   :direction - ソート方向,'asc'または'desc'.Defaultは,'asc'
  # == options
  # :action => action.デフォルトは,'index'
  def site_pages_path(args = {})
    url_for( :controller => "pages", 
    :action => if args[:action].blank? then 'index' else args[:action] end,
    :sort => if !args[:sort].blank?  then args[:page]  else nil end,
    :direction => if !args[:sort].blank?  then 
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

  # 指定ページに対するurlパスを返す.
  # 記事(Article)は,Pageモデルまたは、id値.nil指定で省略.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  #   :page - Page番号.Defaultは1
  #   :sort - ソートカラム.
  #   :direction - ソート方向,'asc'または'desc'.Defaultは,'asc'
  # == options
  # :action => action.デフォルトは,'show'
  def site_page_path(page, args = {})
    url_for( :controller => "pages", 
      :action => if args[:action].blank? then 
      if params[:action] == 'edit'
        'update'
      elsif params[:action] == 'new'
        'create'
      else
        'show' 
      end
      else 
        args[:action] 
      end, 
      :id => if page.nil? then params[:id] else
        if page.respond_to?(:id) then  page.id else page end 
      end,
      :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
      :direction => if !params[:direction].blank?  then params[:direction]  else nil end
      )
  end
  
  # 新規ページ作成のUrlパスを返す.
  def new_site_page_path
    site_page_path(nil, :action => :new)
  end
  
  # ページモデルに対する公開状態の表示名を返す.
  def published_name(page)
    Category::Published.name_with_bool(page.published)
  end
  
end
