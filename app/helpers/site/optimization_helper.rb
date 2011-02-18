# = Site::OptimizationHelper
# SEO設定の view helper
module Site::OptimizationHelper
  
  # urlパスを返す.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  # == options
  # :action => action.デフォルトは,'index'
  def site_optimization_path(options = {})
    url_for( :controller => "optimization", 
    :action => if options[:action].blank? then 'index' else options[:action] end)
  end
  
end
