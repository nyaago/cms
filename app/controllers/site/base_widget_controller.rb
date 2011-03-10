# = Site::BaseWidgetController
#
class Site::BaseWidgetController < Site::BaseController
  
  def edit
    
    site_widget = @site.site_widgets.where("id = :id", :id => params[:id]).first
    @widget = site_widget.widget unless site_widget.nil?
    if @widget.nil?
      render :text => ''
      return
    end
  
    respond_to do |format|
      format.html do
        render :layout => false
      end
    end
    
  end
  
  def update
    site_widget = @site.site_widgets.where('id = :id', :id => params[:id]).first;
    if site_widget.nil? || site_widget.widget.nil?
      render :json => { :status => "NG" }
      return
    end
    if site_widget.site.id != @site.id
      render :json => { :status => "NG" }
      return
    end
    widget = site_widget.widget

    widget.attributes = params[record_parameter_name.to_sym]
    begin
      ActiveRecord::Base.transaction do
        widget.save!(:validate => true)
        respond_to do |format|
          format.json { render :text => { 'widget_id' => widget.id }.to_json }
        end
      end
    rescue
      respond_to do |format|
        p "==== errors json ======"
        p widget.errors.full_messages.to_json
        format.json { render :json => widget.errors.full_messages }
      end
    end
    
  end
  
  # widget を　削除
  # /site/<widget_type.underscore>/destroy/<id> でリクエストされる.
  def destroy
    site_widget = @site.site_widgets.where('id = :id', :id => params[:id]).first;
    if site_widget.nil? || site_widget.widget.nil?
      render :json => { :status => "NG" }
      return
    end
    if site_widget.site.id != @site.id
      render :json => { :status => "NG" }
      return
    end
    widget = site_widget.widget
    begin
      ActiveRecord::Base.transaction do
        if !widget.destroy
           raises ActiveResource::ResourceInvalid, "failed in destroing"
        end
        respond_to do |format|
          format.json { render :text => { 'widget_id' => widget.id }.to_json }
        end
      end
    rescue
      respond_to do |format|
        format.json { render :json => { :status => "NG" } }
      end
    end
    
  end  
  
  
  protected
  
  def record_parameter_name
    :widget
  end
  
end
