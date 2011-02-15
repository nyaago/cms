# = Site::ImagesHelper
# 画像一覧、アップロードのhelper
module Site::ImagesHelper

  # urlパスを返す.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  #   :page - Page番号.Defaultは1
  #   :sort - ソートカラム.
  #   :direction - ソート方向,'asc'または'desc'.Defaultは,'asc'
  # == options
  # :action => action.デフォルトは,'index'
  def site_images_path(options = {})
    url_for( :controller => "images", 
    :action => if options[:action].blank? then 'index' else options[:action] end,
    :month => if !params[:month].blank?  then params[:month]  else nil end,
    :page => if !params[:page].blank?  then params[:page]  else 1 end,
    :sort => if !options[:sort].blank?  then options[:sort]  else false end,
    :direction => if !options[:sort].blank?  then 
      if !params[:direction].blank? and  params[:direction] == 'asc'
        nil
      else
        'asc'
      end
    else 
      nil
    end,
    :id => false
     )
  end
  
  # 指定画像に対するurlパスを返す.
  # 画像(Image)は,Imageモデル
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  #   :page - Page番号.Defaultは1
  #   :sort - ソートカラム.
  #   :direction - ソート方向,'asc'または'desc'.Defaultは,'asc'
  # == options
  # :action => action.デフォルトは,'show'

  def site_image_path(image, options)
    url_for( :controller => "images", 
        :action => if options[:action].blank? then 'index' else options[:action] end,
        :id =>  if image.nil? then nil else image.id end,
        :month => if !params[:month].blank?  then params[:month]  else nil end,
        :page => if !params[:page].blank?  then params[:page]  else 1 end,
        :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
        :direction => if !params[:direction].blank?  then params[:direction]  else nil end)
  end 
  
  def thumb_tag(image)
    if image.exist?(:thumb) 
      "<img src='#{image.url(:thumb)}' alt='#{image.title}' />".html_safe
    else
      ""
    end
    
  end
  
  def user_image_tag(image, style = nil)
    if image.exist?(style) 
      "<img src='#{image.url(style)}' alt='#{image.title}' />".html_safe
    else
      ""
    end
  end
  
  def image_url(image, style = nil)
    'http://' + request.env['HTTP_HOST'] + request.env['REQUEST_PATH'] +  
      image.url(style)[1..image.url(style).size + 1]
  end
  
end
