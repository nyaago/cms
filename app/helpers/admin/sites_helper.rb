# = Admin::SitesHelper
# サイト管理の view helper
module Admin::SitesHelper
  
  # urlパスを返す.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  #   :page - Page番号.Defaultは1
  #   :sort - ソートカラム.
  #   :direction - ソート方向,'asc'または'desc'.Defaultは,'asc'
  # == options
  # :action => action.デフォルトは,'index'
  def admin_sites_path(options = {})
    url_for( :controller => "admin/sites", 
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

  # 指定Siteに対するurlパスを返す.
  # サイトは,Siteモデルまたは、id値.nil指定で省略.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  #   :page - Page番号.Defaultは1
  #   :sort - ソートカラム.
  #   :direction - ソート方向,'asc'または'desc'.Defaultは,'asc'
  # == options
  # :action => action.デフォルトは,'update'
  def admin_site_path(site = false, options = {})
    url_for(:action => if options[:action].blank? then 
              if params[:action] == 'edit' ||  params[:action] == 'update'
                'update'
              elsif params[:action] == 'new' || params[:action] == 'create'
                'create'
              else
                'update' 
              end
            else 
              options[:action] 
            end, 
            :id => if site.nil? then params[:id] else
                      if site.respond_to?(:id) then  site.id else site 
                      end 
                  end,
            :page => if !params[:page].blank?  then params[:page]  else 1 end,
            :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
            :direction => if !params[:direction].blank?  then params[:direction]  else nil end
              )
  end

  
end
