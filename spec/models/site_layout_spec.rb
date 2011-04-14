require 'spec_helper'

describe SiteLayout do
  
  before do
    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first

    PageArticle.destroy_all('site_id' => @site.id)
    
    # 記事
    @a = PageArticle.make(:name => 'pagea', :is_home => true)
    @b = PageArticle.make(:name => 'pageb')
    @c = PageArticle.make(:name => 'pagec')
    @d = PageArticle.make(:name => 'paged')

    PageArticle.make(:name => 'pagea', :is_home => true, :site_id => @site2.id)
    PageArticle.make(:name => 'pageb', :site_id => @site2.id)
    PageArticle.make(:name => 'pagec', :site_id => @site2.id)
    PageArticle.make(:name => 'paged', :site_id => @site2.id)
  end

  it "title tag formated" do
    site_layout = @site.site_layout
    site_layout.title_tag = 'article_site' 
    site_layout.save!(:validate => false)
    site_layout = SiteLayout.find_by_id(site_layout.id)
    site_layout.title_tag_format.should == '%article_title% - %site_title%' 
    site_layout.title_tag_text(@a).should == "#{@a.title} - #{@site.title}"

    site_layout.title_tag = 'site_article' 
    site_layout.save!(:validate => false)
    site_layout = SiteLayout.find_by_id(site_layout.id)
    site_layout.title_tag_format.should == '%site_title% - %article_title%' 
    site_layout.title_tag_text(@a).should == "#{@site.title} - #{@a.title}"
    
  end
  
  it "theme_stylesheet_path" do
    site_layout = @site.site_layout
    site_layout.theme = "default"
    site_layout.theme_stylesheet_path.should == ::Rails.root.to_s + "/public/themes/default/stylesheets/theme.css"

    site_layout = @site.site_layout
    site_layout.theme = "not_exist"
    site_layout.theme_stylesheet_path.should == nil
    
  end

  it "theme_layout_path_for_rendering" do
    site_layout = @site.site_layout
    site_layout.theme = "school"
    site_layout.theme_layout_path_for_rendering.should == "themes/school/application.html.erb"

    site_layout = @site.site_layout
    site_layout.theme = "not_exist"
    site_layout.theme_layout_path_for_rendering.should == "themes/default/application.html.erb"
    
  end

  it "theme_partial_path_for_rendering" do
    site_layout = @site.site_layout
    site_layout.theme = "school"
    site_layout.theme_partial_path_for_rendering(:footer).should == "layouts/themes/school/footer"

    site_layout = @site.site_layout
    site_layout.theme = "not_exist"
    site_layout.theme_partial_path_for_rendering(:footer).should == "layouts/themes/default/footer"
    
  end
  
  it "locate eye_catch header" do
    site_layout = @site.site_layout
    site_layout.eye_catch_type = "header_area"
    site_layout.save!(:validate => true)
    site_layout.reload
    site_layout.eye_catch_type_location.should == 'header'
  end

  it "locate eye_catch header(banner)" do
    site_layout = @site.site_layout
    site_layout.eye_catch_type = "header_area_banner"
    site_layout.save!(:validate => true)
    site_layout.reload
    site_layout.eye_catch_type_location.should == 'header'
  end
   
  it "locate eye_catch content_area" do
    site_layout = @site.site_layout
    site_layout.eye_catch_type = "content_area"
    site_layout.save!(:validate => true)
    site_layout.reload
    site_layout.eye_catch_type_location.should == 'container'
  end

  it "locate eye_catch main_area" do
    site_layout = @site.site_layout
    site_layout.eye_catch_type = "main_area"
    site_layout.save!(:validate => true)
    site_layout.reload
    site_layout.eye_catch_type_location.should == 'contents'
  end

  it "locate eye_catch none" do
    site_layout = @site.site_layout
    site_layout.eye_catch_type = "none"
    site_layout.save!(:validate => true)
    site_layout.reload
    site_layout.eye_catch_type_location.should == nil
  end



   
end
