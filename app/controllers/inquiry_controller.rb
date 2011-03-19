# = InquiryController
# 問い合わせフォーム/送信
class InquiryController < ApplicationController
  
  # 問い合わせフォームの表示
  def index
    
    @site_inquiry_items = @site.site_inquiry_items.order('position')
    @form = Form::Inquiry.new(:inquiry_items => @site_inquiry_items, :params => params[:form])
    respond_to do |format|
      format.html { render :layout => @site.site_layout.theme_layout_path_for_rendering }
      format.xml  { render :xml => @inquiry_items }
    end
  end
  
  def confirm
    @site_inquiry_items = @site.site_inquiry_items.order('position')
    @form = Form::Inquiry.new(:inquiry_items => @site_inquiry_items, :params => params[:form])
    unless @form.valid?
      respond_to do |format|
        format.html { render :action => :index, 
          :layout => @site.site_layout.theme_layout_path_for_rendering 
          }
        format.xml  { render :xml => @inquiry_items }
      end
      return
    end
    respond_to do |format|
      format.html { render :layout => @site.site_layout.theme_layout_path_for_rendering }
      format.xml  { render :xml => @inquiry_items }
    end
  end
  
  def complete
    @site_inquiry_items = @site.site_inquiry_items.order('position')
    @form = Form::Inquiry.new(:inquiry_items => @site_inquiry_items, :params => params[:form])
    unless @form.valid?
      respond_to do |format|
        format.html { render :action => :index, 
          :layout => @site.site_layout.theme_layout_path_for_rendering 
          }
        format.xml  { render :xml => @inquiry_items }
      end
      return
    end
    
    InquiryMailer.contact_email(@form, @site).deliver
    @form.confirm_to_addresses.each do |confirm_to_address|
      InquiryMailer.confirm_email(@form, @site, confirm_to_address).deliver
    end
    
#    mail.body = mail.body.encode('iso-2022-jp').force_encoding('binary')
#    mail.charset = 'ISO-2022-JP'
    
    respond_to do |format|
      format.html { render :layout => @site.site_layout.theme_layout_path_for_rendering }
      format.xml  { render :xml => @inquiry_items }
    end
  end
  
  
end
