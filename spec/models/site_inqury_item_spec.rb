require 'spec_helper'

describe SiteInquiryItem do

  before do
    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first

    SiteInquiryItem.destroy_all('site_id' => @site.id)
    
    @si1 = SiteInquiryItem.create(:site => @site, :position => 1, :inquiry_item => TextInquiryItem.create)
    @si2 = SiteInquiryItem.create(:site => @site, :position => 2, :inquiry_item => TextInquiryItem.create)
    @si3 = SiteInquiryItem.create(:site => @site, :position => 3, :inquiry_item => TextInquiryItem.create)
    @si4 = SiteInquiryItem.create(:site => @site, :position => 4, :inquiry_item => TextInquiryItem.create)
    @si5 = SiteInquiryItem.create(:site => @site, :position => 5, :inquiry_item => TextInquiryItem.create)
    
  end
  
  it "positions was adjusted when inserting new record" do
    pos = 3
    id_to_position = {}
    @site.site_inquiry_items.order('position').each do |site_inquiry_item|
      id_to_position[site_inquiry_item.id] = site_inquiry_item.position
    end
    SiteInquiryItem.create!(:site => @site, :position => pos, :inquiry_item => TextInquiryItem.create)
    id_to_position.each do |id, position|
      site_inquiry_item = SiteInquiryItem.find_by_id(id)
      if position >= pos
        site_inquiry_item.position.should == position + 1
      else
        site_inquiry_item.position.should == position
      end
    end
    
  end
  
  it "positions was adjusted when inserting new record (position is null)" do
    pos = nil
    id_to_position = {}
    count = 0
    @site.site_inquiry_items.order('position').each do |site_inquiry_item|
      id_to_position[site_inquiry_item.id] = site_inquiry_item.position
      count += 1
    end
    new_inquiry_item = SiteInquiryItem.create!(:site => @site, :position => pos, :inquiry_item => TextInquiryItem.create)
    id_to_position.each do |id, position|
      site_inquiry_item = SiteInquiryItem.find_by_id(id)
      site_inquiry_item.position.should == position
    end
    new_inquiry_item.reload
    new_inquiry_item.position.should == (count + 1)
  end

  
  it "sort with ordered" do
    order = [@si2, @si1, @si3, @si4, @si5]
    ids = []
    order.each do |si|
      ids << si.id
    end
    SiteInquiryItem.sort_with_ordered(@site, ids)
    order.each do |si|
      SiteInquiryItem.find_by_id(si.id).position.should == order.index(si) + 1
    end
    
  end
  
end
