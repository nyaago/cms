# -*- coding: utf-8 -*-
require 'spec_helper'

SITE_ID = 1

describe Figure::Site::Capacity do

  before  do 

    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first

    PageArticle.destroy_all('site_id' => @site.id)
    
    # 記事
    @pagea = PageArticle.make(:name => 'pagea', :is_home => true)
    @pageb = PageArticle.make(:name => 'pageb')
    @pagec = PageArticle.make(:name => 'pagec')
    @paged = PageArticle.make(:name => 'paged')

    PageArticle.make(:name => 'pagea', :is_home => true, :site_id => @site2.id)
    PageArticle.make(:name => 'pageb', :site_id => @site2.id)
    PageArticle.make(:name => 'pagec', :site_id => @site2.id)
    PageArticle.make(:name => 'paged', :site_id => @site2.id)


  end
  
  it "used capacity containing user images and images for layout" do
    capacity = 0
    image = Image.new
    image.site_id = @site.id
    image.user = @user
    begin
      image.image = uploaded_file('ムーミンおやつ2.jpg', 'image/jpg')
      image.save!(:validate => true)
      image.reload
      capacity += image.total_size
    rescue => ex
      p ex.backtrace
      raise ex
    end
    
    image = Image.new
    image.site_id = @site.id
    image.user = @user
    begin
      image.image = uploaded_file('ごろにゃん1.png', 'image/png')
      image.save!(:validate => true)
      image.reload
      capacity += image.total_size
    rescue => ex
      p ex.backtrace
      raise ex
    end

    image = LayoutImage.new
    image.site_id = @site.id
    image.user = @user
    begin
      image.image = uploaded_file('footer.jpg', 'image/jpg')
      image.save!(:validate => true)
      image.reload
      capacity += image.image_file_size
    rescue => ex
      p ex.backtrace
      raise ex
    end

    image = LayoutImage.new
    image.site_id = @site.id
    image.user = @user
    image.article = @pagea
    begin
      image.image = uploaded_file('header.jpg', 'image/jpg')
      image.save!(:validate => true)
      image.reload
      capacity += image.image_file_size
    rescue => ex
      p ex.backtrace
      raise ex
    end
    
    @site.used_capacity.should == capacity
    
  end
  
end
