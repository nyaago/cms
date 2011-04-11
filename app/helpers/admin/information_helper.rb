module Admin::InformationHelper
  
  # 指定informationに対するurlパスを返す.
  # informationは,Informationモデルまたは、id値.nil指定で省略.
  # 以下のリクエストパラメーター(params)を参照.Urlのパラメーターに追加する.
  #   :page - Page番号.Defaultは1
  #   :sort - ソートカラム.
  #   :direction - ソート方向,'asc'または'desc'.Defaultは,'asc'
  # == options
  # :action => action.デフォルトは,'update'
  def admin_information_path(information = false, options = {})
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
            :id => if information.nil? then 
                      params[:id] 
                    else
                      if information.respond_to?(:id) then  
                        information.id 
                      else 
                        information 
                      end 
                    end,
            :page => if !params[:page].blank?  then params[:page]  else 1 end,
            :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
            :direction => if !params[:direction].blank?  then params[:direction]  else nil end
              )
  end
  
end
