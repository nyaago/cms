# = SiteAdmin::PostSettingHelper
# 投稿設定の view helper
module SiteAdmin::PostSettingHelper

  # urlパスを返す.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  # == options
  # :action => action.デフォルトは,'index'
  def site_post_setting_path(options = {})
    url_for( :controller => "post_setting", 
    :action => if options[:action].blank? then 'index' else options[:action] end)
  end

end
