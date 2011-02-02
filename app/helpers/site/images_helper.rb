# = Site::ImagesHelper
# 画像一覧、アップロードのhelper
module Site::ImagesHelper
  
  # urlを返す
  def site_image_path(image, options)
    url_for( :controller => "images", 
    :action => if options[:action].blank? then 'index' else options[:action] end)
  end 
end
