require 'spec_helper'

describe SiteWidget do

  before do
    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first

    SiteWidget.destroy_all('site_id' => @site.id)
    
    @sw1 = SiteWidget.create(:site => @site, :position => 1, :area => :side, :widget => TextWidget.create)
    @sw2 = SiteWidget.create(:site => @site, :position => 2, :area => :side, :widget => TextWidget.create)
    @sw3 = SiteWidget.create(:site => @site, :position => 3, :area => :side, :widget => TextWidget.create)
    @sw4 = SiteWidget.create(:site => @site, :position => 4, :area => :side, :widget => TextWidget.create)
    @sw5 = SiteWidget.create(:site => @site, :position => 5, :area => :side, :widget => TextWidget.create)
    
  end
  
  it "positions was adjusted when inserting new record" do
    pos = 3
    id_to_position = {}
    @site.site_widgets.order('position').each do |site_widget|
      id_to_position[site_widget.id] = site_widget.position
    end
    SiteWidget.create!(:site => @site, :area => :side, :position => pos, :widget => TextWidget.create)
    id_to_position.each do |id, position|
      site_widget = SiteWidget.find_by_id(id)
      if position >= pos
        site_widget.position.should == position + 1
      else
        site_widget.position.should == position
      end
    end
    
  end
  
  it "sort with ordered" do
    order = [@sw2, @sw1, @sw3, @sw4, @sw5]
    ids = []
    order.each do |sw|
      ids << sw.id
    end
    SiteWidget.sort_with_ordered(@site, :side, ids)
    order.each do |sw|
      SiteWidget.find_by_id(sw.id).position.should == order.index(sw) + 1
    end
    
  end
  
end
