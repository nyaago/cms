require 'spec_helper'

describe SiteLayout do
  
  before do
    @site = Site.all.first
    @site2 = Site.all[1]
    @admin = User.all.first
    @admin2 = User.make(:admin, :login => 'admin2', :email => 'admin2@hoge.com')
    @site_admin1 = User.make(:site_admin, :login => 'site_admin1', :email => 'site_admin1@hoge.com', :site => @site)
    @site_admin2 = User.make(:site_admin, :login => 'site_admin2', :email => 'site_admin2@hoge.com', :site => @site)
    
    User.make(:login => 'user1', :email => 'user1@hoge.com', :site => @site)
    User.make(:login => 'user2', :email => 'user2@hoge.com', :site => @site)

  end

  it "can  site admin to general user " do
    @site_admin2.is_site_admin = false
    @site_admin2.should be_valid
  end 

  it "can  site admin to general user if only site admin" do
    @site_admin2.is_site_admin = false
    @site_admin2.save!(:validate => false)
    @site_admin1.is_site_admin = false
    @site_admin1.should_not be_valid
  end 
  
  it "only site admin?  " do
    @site_admin2.only_site_admin?.should == false
    @site_admin2.is_site_admin = false
    @site_admin2.save!(:validate => false)
    @site_admin1.only_site_admin?.should == true
  end 

  it "only admin?  " do
    @admin2.only_admin?.should == false
    @admin2.is_admin = false
    @admin2.save!(:validate => false)
    @admin.only_admin?.should == true
  end 
   
end
