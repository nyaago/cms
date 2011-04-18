# = SiteAdmin::LayoutHelper
# レイアウトデザイン設定の view helper
module SiteAdmin::LayoutHelper
  
  # urlパスを返す.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  # == options
  # :action => action.デフォルトは,'index'
  def site_layout_path(options = {})
    url_for( :controller => "layout", 
    :action => if options[:action].blank? then 'index' else options[:action] end)
  end
  
  def layout_image_tag(site_layout, location_type)
    if site_layout.respond_to?("#{location_type}_image_url".to_sym)
      url = site_layout.send("#{location_type}_image_url".to_sym)
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
