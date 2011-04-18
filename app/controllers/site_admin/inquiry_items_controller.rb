# = SiteAdmin::InquiryItemsController
# 
class SiteAdmin::InquiryItemsController < SiteAdmin::BaseController
  
  def index
    @inquiry_items = Layout::InquiryItem.load
    @selected_items = @site.site_inquiry_items.order('position')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @selected_items }
    end
    
  end
  
  # サイトにInquiry Item(問い合わせ項目)を追加する
  # リクエストパラメーターとして以下のものが送信されてくることを期待している.
  # * inquiry_item_type - inquiry item のタイプ. inquiry itemのモデルクラス名と等しい値.
  # * position - 並び順
  def create
    clazz = unless params[:inquiry_item_type].blank?
      begin
        params[:inquiry_item_type].split(/::/).inject(Object) {|c,name| c.const_get(name) }
      rescue
        nil
      end
    else
      nil
    end
    position = unless params[:position].blank? || params[:position].to_i.zero?
      params[:position].to_i
    else
      0
    end
    
    if clazz.nil?  # error
      respond_to do |format|
        format.json  { render :json => { :status => "NG" } }
        format.xml  { render :xml => 'failed in creating inquiry item' }
        format.html  { render :html => 'failed in creating inquiry item' }
      end
      return
    end
    inquiry_item = clazz.new(:user => current_user)
    
    begin
      ActiveRecord::Base.transaction do
        inquiry_item.save!(:validate => false) && 
        site_inquiry_item = SiteInquiryItem.create!(:site => @site,  
                                        :inquiry_item => inquiry_item, 
                                        :position => position,
                                        :user => current_user
                                        ) 
        respond_to do |format|
          format.json do
            render :text => {:inquiry_item => inquiry_item.attributes, 
                            :site_inquiry_item => site_inquiry_item.attributes}.to_json
          end
          format.xml do
            render :xml => [inquiry_item.attributes, site_inquiry_item.attributes]
          end
          format.html do
            render :text => '<p>inquiry item created</p>'
          end
        end
      end
    rescue => ex      # error
      p ex.backtrace
      p ex.message
      respond_to do |format|
        format.json  { render :json => { :status => "NG" } }
        format.xml  { render :xml => 'failed in creating inquiry item' }
        format.html  { render :html => 'failed in creating inquiry item' }
      end
    end
  end
  
  # 並び変え操作
  # == 以下のリクエストパラメータが送信されることを期待する
  # * order - 更新すべき並び順に格納されている site_widget の id のcsv文字列.
  def sort
    ordered = unless params[:order].blank?
      params[:order].split(/,/).collect do |v|
        v.to_i
      end
    else
      nil
    end
    if ordered.nil?
      respond_to do |format|
        format.json  { render :json => { :status => 'NG' } }
        format.xml  { render :xml => 'NG' }
        format.html  { render :html => 'NG' }
      end
      return 
    end
    
    begin
      ActiveRecord::Base.transaction do
        SiteInquiryItem.sort_with_ordered(@site, ordered)
        respond_to do |format|
          format.json  { render :json => { :status => 'OK' } }
          format.xml  { render :xml => 'OK' }
          format.html  { render :html => 'OK' }
        end
      end
    rescue => e
      respond_to do |format|
        format.json  { render :json => { :status => 'NG' } }
        format.xml  { render :xml => 'NG' }
        format.html  { render :html => 'NG' }
      end
    end

  end
  
end
