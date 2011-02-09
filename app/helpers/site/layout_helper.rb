module Site::LayoutHelper
  
  # urlパスを返す.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  # == options
  # :action => action.デフォルトは,'index'
  def site_layout_path(options = {})
    url_for( :controller => "layout", 
    :action => if options[:action].blank? then 'index' else options[:action] end)
  end
  
end
