# = Site::TemplateHelper
#
module Site::ThemeHelper

  # urlパスを返す.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  # == options
  # :action => action.デフォルトは,'index'
  def site_theme_path(options = {})
    url_for( :controller => "theme", 
    :action => if options[:action].blank? then 'index' else options[:action] end)
  end

end
