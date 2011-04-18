# = SiteAdmin::BaseInquiryItemController
# 各問い合わせ項目の編集を行うベース controller
module SiteAdmin

  class BaseInquiryItemController < BaseController
  
    # 編集ページを表示
    # /site/<inquiry_item_type.underscore>/edit/<id> でリクエストされる.
    def edit
    
      @site_inquiry_item = @site.site_inquiry_items.where("id = :id", :id => params[:id]).first
      @inquiry_item = @site_inquiry_item.inquiry_item unless @site_inquiry_item.nil?
      if @inquiry_item.nil?
        render :text => ''
        return
      end
  
      respond_to do |format|
        format.html do
          render :layout => false
        end
      end
    
    end
  
    # 編集内容での更新を行う
    # /site/<inquiry_item_type.underscore>/update/<id> でPostリクエストされる.
    def update
      site_inquiry_item = @site.site_inquiry_items.where('id = :id', :id => params[:id]).first;
      if site_inquiry_item.nil? || site_inquiry_item.inquiry_item.nil?
        render :json => { :status => "NG" }
        return
      end
      if site_inquiry_item.site.id != @site.id
        render :json => { :status => "NG" }
        return
      end
      inquiry_item = site_inquiry_item.inquiry_item

      inquiry_item.attributes = params[record_parameter_name.to_sym]
      site_inquiry_item.attributes = params[:site_inquiry_item]
      inquiry_item.user = current_user
      begin
        ActiveRecord::Base.transaction do
          inquiry_item.save!(:validate => true)
          site_inquiry_item.save!(:validate => true)
          respond_to do |format|
            format.json { render :text => { 'inquiry_item' => inquiry_item.attributes }.to_json }
          end
        end
      rescue
        respond_to do |format|
          format.json { render :json => inquiry_item.errors.full_messages }
        end
      end
    
    end
  
    # inquiry item を　削除
    # /site/<inquiry_item_type.underscore>/destroy/<id> でリクエストされる.
    def destroy
      site_inquiry_item = @site.site_inquiry_items.where('id = :id', :id => params[:id]).first;
      if site_inquiry_item.nil? || site_inquiry_item.inquiry_item.nil?
        render :json => { :status => "NG" }
        return
      end
      if site_inquiry_item.site.id != @site.id
        render :json => { :status => "NG" }
        return
      end
      inquiry_item = site_inquiry_item.inquiry_item
      begin
        ActiveRecord::Base.transaction do
          if !inquiry_item.destroy
            raises ActiveResource::ResourceInvalid, "failed in destroing"
          end
          respond_to do |format|
            format.json { render :text => { 'inquiry_item_id' => inquiry_item.id }.to_json }
          end
        end
      rescue => ex
        p ex.message
        p ex.backtrace
        respond_to do |format|
          format.json { render :json => { :status => "NG" } }
        end
      end
    
    end  
  
  
    protected
  
    # 更新リクエストでのデータを格納するパラメータ名をを返す.
    # 各継承クラスでオーバーライドする.
    def record_parameter_name
      :inquiry_item
    end
  
  end

  # 定義(config/layouts/widget.yml)を読み込み、各具象widget controller クラスを定義
  Layout::InquiryItem.load.each do |item|
    puts "new class - #{item.name.capitalize.camelize}"
    self.const_set("#{item.name.capitalize.camelize}", Class.new(BaseInquiryItemController) {
      def record_parameter_name
        self.class.name.split('::').last.underscore
      end
    } )
  end


end
