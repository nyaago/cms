# -*- coding: utf-8 -*-
require 'spec_helper'

describe Image do
  before  do 

    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first

    Image.destroy_all('site_id' => @site.id)
    
    image = Image.new
    image.site_id = @site.id
    image.user = @user
    begin
      image.image = uploaded_file('ごろにゃん1.png', 'image/png')
    rescue => ex
      p ex.backtrace
      raise ex
    end
    image.save!(:validate => true)
    image.reload
    image.title = "image title"
    image.save!(:validate => true)

    image = Image.new
    image.site_id = @site.id
    image.user = @user
    begin
      image.image = uploaded_file('ごろにゃん1.png', 'image/png')
    rescue => ex
      p ex.backtrace
      raise ex
    end
    image.save!(:validate => true)
    image.reload
    image.title = "image title"
    image.save!(:validate => true)

    image = Image.new
    image.site_id = @site.id
    image.user = @user
    begin
      image.image = uploaded_file('url_and_resources.xls', 'application/vnd.ms-excel')
    rescue => ex
      p ex.backtrace
      raise ex
    end
    image.save!(:validate => true)
    image = Image.find_by_id(image.id)
    image.title = "excel title"
    begin
      image.save!(:validate => true)
    rescue => ex
      p ex.message
      p ex.backtrace
      raise ex
    end
    
  end
  
  it "upload jpg" do
    image = Image.new
    image.site_id = @site.id
    image.user = @user
    begin
      image.image = uploaded_file('ムーミンおやつ2.jpg', 'image/jpg')
#      image.image = mock_uploader('user.jpg', 'image/jpg')
    rescue => ex
      p ex.backtrace
      raise ex
    end
    
    image.should be_valid
    image.save!(:validate => true)

    image.reload
    image.image.should_not be_nil
    image.title = "image title"
    image.save!(:validate => true)
    image.reload

    image.total_size.should == File.size(image.path(:original)) +
                              File.size(image.path(:small)) +
                              File.size(image.path(:medium)) +
                              File.size(image.path(:thumb))
    image.exist_all_style?.should == true
    image.image_content_type?.should == true
  end

  it "upload png" do
    image = Image.new
    image.site_id = @site.id
    image.user = @user
    begin
      image.image = uploaded_file('ごろにゃん1.png', 'image/png')
#      image.image = mock_uploader('user.jpg', 'image/jpg')
    rescue => ex
      p ex.backtrace
      raise ex
    end

    image.should be_valid
    image.save!(:validate => true)

    image.reload
    image.image.should_not be_nil
    image.title = "image title"
    image.save!(:validate => true)
    image.reload

    image.total_size.should == File.size(image.path(:original)) +
                              File.size(image.path(:small)) +
                              File.size(image.path(:medium)) +
                              File.size(image.path(:thumb))
    image.exist_all_style?.should == true
    image.image_content_type?.should == true
  end

  it "upload excel" do
    image = Image.new
    image.site_id = @site.id
    image.user = @user
    begin
      image.image = uploaded_file('url_and_resources.xls', 'application/vnd.ms-excel')
#      image.image = mock_uploader('user.jpg', 'image/jpg')
    rescue => ex
      p ex.backtrace
      raise ex
    end
    
    image.should be_valid
    image.save!(:validate => true)

    image = Image.find_by_id(image.id)
    image.should be_valid
    image.image.should_not be_nil
    image.title = "excel title"
    begin
      image.save!(:validate => true)
    rescue => ex
      p '##########################################'
      p ex.message
      p ex.backtrace
      raise ex
    end
    image.reload

    image.total_size.should == File.size(image.path(:original))
    image.exist_all_style?.should == false
    image.image_content_type?.should == false
  end
  
    it "updated month is selected" do
      months = Image.updated_months(@site.id)
      months[0].to_s.should == Image::Month.new(Time.now.year, Time.now.month).to_s
      image = @site.images[0]
      Image.connection.execute("update images set updated_at = '"  + 
              Time.now.years_ago(1).strftime("%Y-%m-%d") + "'" +
               " WHERE id = #{image.id}")
      months = Image.updated_months(@site.id, 'asc')
      months[1].to_s.should == Image::Month.new(Time.now.year, Time.now.month).to_s
      months[0].to_s.should == Image::Month.new(Time.now.year - 1, Time.now.month).to_s

    end

    it "created month is selected" do
      months = Image.created_months(@site.id)
      months[0].to_s.should == Image::Month.new(Time.now.year, Time.now.month).to_s
      image = @site.images[0]
      Image.connection.execute("update images set created_at = '"  + 
              Time.now.years_ago(1).strftime("%Y-%m-%d") + "'" +
               " WHERE id = #{image.id}")
      months = Image.created_months(@site.id, 'asc')
      months[1].to_s.should == Image::Month.new(Time.now.year, Time.now.month).to_s
      months[0].to_s.should == Image::Month.new(Time.now.year - 1, Time.now.month).to_s

    end
  

end
