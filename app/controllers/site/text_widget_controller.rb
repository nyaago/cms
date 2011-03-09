# = Site::TextWidgetController
#
class Site::TextWidgetController < Site::BaseController
  
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

    widget.attributes = params[:text_widget]
    begin
      ActiveRecord::Base.transaction do
        widget.save!(:validate => true)
        respond_to do |format|
          format.json { render :text => { 'widget_id' => widget.id }.to_json }
        end
      end
    rescue
      respond_to do |format|
        format.json { render :json => widget.errors }
      end
    end
    
  end
  
end
