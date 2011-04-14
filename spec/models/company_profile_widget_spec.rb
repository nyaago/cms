# -*- coding: utf-8 -*-
require 'spec_helper'

describe CompanyProfileWidget do
  
  before  do 

    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first
  
  end
  
  it "email including conma be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => "pan.pon@gmail.com")
    widget.should be_valid
  
  end

  it "email including wide char be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => "ぽんぽこ@gmail.com")
    widget.should be_valid
  
  end


  it "email including sign char be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => '!#$%&*+-/=?^_`{|}~@gmail.com')
    widget.should be_valid
  
  end
  
  it 'email including sign char(!#$%&*+-/=?^_`{|}~) be valid ' do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => 'aaa!#$%&*+-/=?^_`{|}~@gmail.com')
    widget.should be_valid
  
  end
  
  it "email including sign char be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => "quoute'q@gmail.com")
    widget.should be_valid
  
  end
  

  it "email starting by .  not be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => ".comma@gmail.com")
    widget.should_not be_valid
  
  end

  it "email including (parentheses) not be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => "p(parentheses)@gmail.com")
    widget.should_not be_valid
  
  end
  
  it "email including [brackets] not be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => "p[brackets]@gmail.com")
    widget.should_not be_valid
  
  end
  
  it "email including [brackets] not be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => "p[brackets]@gmail.com")
    widget.should_not be_valid
  
  end

# not implimatation =>   
#  it "email including .. not be valid " do
#    
#    widget = CompanyProfileWidget.new(:name => "company1",
#                    :email => "dot..dot@gmail.com")
#    widget.should_not be_valid
#  
#  end

  it "email domain including -  be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => "mail@g-mail.com")
    widget.should be_valid
  
  end
  
  it "email domain staring .  not be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => "mail@.gmail.com")
    widget.should_not be_valid
  
  end
  
  it "email domain ending .  not be valid " do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :email => "mail@gmail.com.")
    widget.should_not be_valid
  
  end
  

  it "http link includin japanese be valid" do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :link_url1 => "http://ほげほげ")
    widget.should be_valid
  
  end
  

  it "https link includin japanese be valid" do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :link_url1 => "https://ほげほげ")
    widget.should be_valid
  
  end
  

  it "htt link includin japanese be valid" do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :link_url1 => "htt://hogehoge")
    widget.should_not be_valid
  
  end
  
  it "link not includin protocal not be valid" do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :link_url1 => "hogehoge")
    widget.should_not be_valid
  
  end

  it "link staring by / not be valid" do
    
    widget = CompanyProfileWidget.new(:name => "company1",
                    :link_url1 => "/hogehoge")
    widget.should_not be_valid
  
  end

end
