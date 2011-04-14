# *-* coding: utf-8 *-*
require 'spec_helper'

describe PostSetting do
  before do
    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first

  end
  
  it "pop3 password" do
    post_setting = @site.post_setting
    post_setting.pop3_password = 'hogepon'
    post_setting.pop3_host = 'localhost'
    post_setting.pop3_port = 110
    post_setting.pop3_login = 'nyanpon'
    post_setting.save!(:validate => true)
    
    post_setting = PostSetting.find_by_id(post_setting.id)
    post_setting.pop3_password.should == 'hogepon'
  end

  it "pop3 not valid unless port " do
    post_setting = @site.post_setting
    post_setting.pop3_password = 'hogepon'
    post_setting.pop3_host = 'localhost'
    post_setting.pop3_port = ''
    post_setting.pop3_login = 'nyanpon'
    
    post_setting.should_not be_valid
    
  end

  it "pop3 not valid unless port be numerically " do
    post_setting = @site.post_setting
    post_setting.pop3_password = 'hogepon'
    post_setting.pop3_host = 'localhost'
    post_setting.pop3_port = 'port'
    post_setting.pop3_login = 'nyanpon'
    
    post_setting.should_not be_valid
    
  end



  it "pop3 not valid unless password " do
    post_setting = @site.post_setting
    #post_setting.pop3_password = 'hogepon'
    post_setting.pop3_host = 'localhost'
    post_setting.pop3_port = 110
    post_setting.pop3_login = 'nyanpon'
    
    post_setting.should_not be_valid
    
  end

  it "pop3 not valid unless host " do
    post_setting = @site.post_setting
    post_setting.pop3_password = 'hogepon'
    #post_setting.pop3_host = 'localhost'
    post_setting.pop3_port = 110
    post_setting.pop3_login = 'nyanpon'
    
    post_setting.should_not be_valid
    
  end

  it "pop3  valid if all blank except port " do
    post_setting = @site.post_setting
    post_setting.pop3_password = ''
    post_setting.pop3_host = ''
    post_setting.pop3_port = 110
    post_setting.pop3_login = ''
    
    post_setting.should be_valid
    
  end

  
  it "pop3 host no valid if including multi chars " do
    post_setting = @site.post_setting
    post_setting.pop3_password = 'hogepon'
    post_setting.pop3_host = 'ほげほん'
    post_setting.pop3_port = 110
    post_setting.pop3_login = 'nyanpon'
    
    post_setting.should_not be_valid
    
  end

  it "pop3 host no valid if starting with dot " do
    post_setting = @site.post_setting
    post_setting.pop3_password = 'hogepon'
    post_setting.pop3_host = '.gmail.com'
    post_setting.pop3_port = 110
    post_setting.pop3_login = 'nyanpon'
    
    post_setting.should_not be_valid
    
  end
  
  it "pop3 host no valid if ending with dot " do
    post_setting = @site.post_setting
    post_setting.pop3_password = 'hogepon'
    post_setting.pop3_host = 'gmail.com.'
    post_setting.pop3_port = 110
    post_setting.pop3_login = 'nyanpon'
    
    post_setting.should_not be_valid
    
  end
  

  it "pop3 host be valid if separated with dot " do
    post_setting = @site.post_setting
    post_setting.pop3_password = 'hogepon'
    post_setting.pop3_host = 'gmail.com'
    post_setting.pop3_port = 110
    post_setting.pop3_login = 'nyanpon'
    
    post_setting.should be_valid
    
  end

  it "pop3 host including hyphen be valid  " do
    post_setting = @site.post_setting
    post_setting.pop3_password = 'hogepon'
    post_setting.pop3_host = 'g-mail.com'
    post_setting.pop3_port = 110
    post_setting.pop3_login = 'nyanpon'
    
    post_setting.should be_valid
    
  end
  

  
end
