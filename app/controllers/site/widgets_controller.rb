# = Site::WidgetsController
# 表示設定
class Site::WidgetsController < Site::BaseController
  
  def index
    @widgets = Layout::Widget.load
    @widgets_on_side = @site.site_widgets.where('area = :area', :area => 'side').
                                        order('position')
    @widgets_on_footer = @site.site_widgets.where('area = :area', :area => 'footer').
                                        order('position')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @selected_widget }
    end
    
  end

  # サイトにWidgetを追加する
  # リクエストパラメーターとして以下のものが送信されてくることを期待している.
  # * widget_type - widget のタイプ. widgetのモデルクラス名と等しい値.
  # * widget_area - Widgetを入りするarea. side | footer
  # * position - 並び順
  def create
    clazz = unless params[:widget_type].blank?
      begin
        params[:widget_type].split(/::/).inject(Object) {|c,name| c.const_get(name) }
      rescue
        nil
      end
    else
      nil
    end
    area = unless params[:widget_area].blank?
      params[:widget_area]
    else
      nil
    end
    position = unless params[:position].blank? || params[:position].to_i.zero?
      params[:position].to_i
    else
      0
    end
    
    if clazz.nil? || area.nil? # error
      respond_to do |format|
        format.json  { render :json => 'failed in creating widget' }
        format.xml  { render :xml => 'failed in creating widget' }
        format.html  { render :html => 'failed in creating widget' }
      end
      return
    end
    widget = clazz.new
    
    begin
      ActiveRecord::Base.transaction do
        widget.save!(:validate => false) && 
        site_widget = SiteWidget.create!(:site => @site,  
                                        :area => area, 
                                        :widget => widget, 
                                        :position => position) 
        site_widget.adjust_positions
          
        respond_to do |format|
          format.json do
            render :text => {:widget => widget.attributes, :site_widget => site_widget.attributes}.to_json
          end
          format.xml do
            render :xml => [widget.attributes, site_widget.attributes]
          end
          format.html do
            render :text => '<p>widget created</p>'
          end
        end
      end
    rescue      # error
      respond_to do |format|
        format.json  { render :json => 'failed in creating widget' }
        format.xml  { render :xml => 'failed in creating widget' }
        format.html  { render :html => 'failed in creating widget' }
      end
    end
  end
  
end
