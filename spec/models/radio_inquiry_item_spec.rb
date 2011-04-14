# *-* coding: utf-8 *-*
require 'spec_helper'

describe RadioInquiryItem do
  before do
    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first

  end

  it "omit one empty value" do
    item = RadioInquiryItem.new
    item.save!(:validate => true)
    item = RadioInquiryItem.find_by_id(item.id)
    item.title = "ラジオ"
    item.value1 = "選択肢1"
    item.value3 = "選択肢2"
    item.value4 = "選択肢3"        
    item.default_index = 4
    item.save!(:validate => true)
    item.reload
    item.value1.should == "選択肢1"
    item.value2.should == "選択肢2"
    item.value3.should == "選択肢3"
    item.value4.should == nil
    item.value5.should == nil
    item.value6.should == nil
    item.default_index.should == (4-1)
  end

  it "omit plural  empty value" do
    item = RadioInquiryItem.new
    item.save!(:validate => true)
    item = RadioInquiryItem.find_by_id(item.id)
    item.title = "ラジオ"
    item.value1 = "選択肢1"
    item.value4 = "選択肢2"
    item.value5 = "選択肢3"        
    item.default_index = 4
    item.save!(:validate => true)
    item.reload
    item.value1.should == "選択肢1"
    item.value2.should == "選択肢2"
    item.value3.should == "選択肢3"
    item.value4.should == nil
    item.value5.should == nil
    item.value6.should == nil
    item.default_index.should == (4-2)
  end

  it "omit plural  empty value (default index = 1)" do
    item = RadioInquiryItem.new
    item.save!(:validate => true)
    item = RadioInquiryItem.find_by_id(item.id)
    item.title = "ラジオ"
    item.value1 = "選択肢1"
    item.value4 = "選択肢2"
    item.value5 = "選択肢3"        
    item.default_index = 1
    item.save!(:validate => true)
    item.reload
    item.value1.should == "選択肢1"
    item.value2.should == "選択肢2"
    item.value3.should == "選択肢3"
    item.value4.should == nil
    item.value5.should == nil
    item.value6.should == nil
    item.default_index.should == 1
  end

  it "omit plural  empty value (at intervals)" do
    item = RadioInquiryItem.new
    item.save!(:validate => true)
    item = RadioInquiryItem.find_by_id(item.id)
    item.title = "ラジオ"
    item.value2 = "選択肢1"
    item.value4 = "選択肢2"
    item.value6 = "選択肢3"        
    item.default_index = 4
    item.save!(:validate => true)
    item.reload
    item.value1.should == "選択肢1"
    item.value2.should == "選択肢2"
    item.value3.should == "選択肢3"
    item.value4.should == nil
    item.value5.should == nil
    item.value6.should == nil
    item.default_index.should == (4-2)
  end

  
end
