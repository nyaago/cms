module SiteAdmin

  # = SiteAdmin::BaseWidgetController
  # Widget 編集 の Base Controller
  class BaseWidgetController < BaseController
    
  
    # 編集ページを表示
    # /site/<widget_type.underscore>/edit/<id> でリクエストされる.
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
  
    # 編集ページを表示
    # /site/<widget_type.underscore>/update/<id> でPostリクエストされる.
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
      widget.user = current_user
      begin
        ActiveRecord::Base.transaction do
          widget.save!(:validate => true)
          respond_to do |format|
            format.json { render :text => { 'widget_id' => widget.id }.to_json }
          end
        end
      rescue
        respond_to do |format|
          format.json { render :json => widget.errors.full_messages }
        end
      end
    
    end
  
    # 編集内容での更新を行う
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
  
  #  def self.define_subclass(name)
  #  end
  
    protected
  
    # 更新リクエストでのデータを格納するパラメータ名をを返す.
    # 各継承クラスでオーバーライドする.
    def record_parameter_name
      :widget
    end
  
  end

  # = 各Widget Controller 生成
  # 定義(config/layouts/widget.yml)を読み込み、各具象widget controller クラスを定義
  Layout::Widget.load.each do |widget|
    puts "new class - #{widget.name.capitalize.camelize}"
    self.const_set("#{widget.name.capitalize.camelize}Controller", 
        Class.new(BaseWidgetController) {
      def record_parameter_name
        self.class.name.split('::').last[0,self.class.name.split('::').last.
          index('Controller')].underscore
      end
    } )
  end
  
end