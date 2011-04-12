require 'spec_helper'

SITE_ID = 1

describe PageArticle do

  before  do 
#    @site = Site.new(:name => 'moomin', :title => 'moomin')
#    @user = User.new(:login => 'moomin', :email => 'nyaago69@gmail.com')
#    @user.password = @user.password_confirmation = 'moomin'
#    @user.is_site_admin = true
#    @user.site = @site
#    @user.save!
#    @site.save!
    @site = Site.all.first
    @user = User.all.first

    PageArticle.destroy_all('site_id' => @site.id)
    
    # 記事
    a = PageArticle.make(:name => 'pagea')
    b = PageArticle.make(:name => 'pageb')
    c = PageArticle.make(:name => 'pagec')
    d = PageArticle.make(:name => 'paged')

    # temporary 記事
    t = PageArticle.new
    t.attributes = a.attributes
    t.parent_id = a.id
    t.is_temporary = true
    t.save!(:validate => false)
    t = PageArticle.new
    t.attributes = c.attributes
    t.parent_id = c.id
    t.is_temporary = true
    t.save!(:validate => false)
    
  end

  it "next order from 1 to 2" do
    @article = PageArticle.where('site_id = :site_id', :site_id => @site.id).
            offset(0).
            limit(1).
            order('menu_order').first
    id = @article.id
    @article.to_next_menu_order
    @article = Article.find_by_id(id)
    @article.menu_order.should  == 2
  end

  it "next order from 2 to 3" do
    @article = @site.pages.where('site_id = :site_id', :site_id => @site.id).
            offset(1).
            limit(1).
            order('menu_order').first
    id = @article.id
    @article.to_next_menu_order
    @article = Article.find_by_id(id)
    @article.menu_order.should  == 3
  end

  it "next order from last" do
    @article = @site.pages.where('site_id = :site_id', :site_id => @site.id).
            last
    id = @article.id
    @article.to_next_menu_order
    @article = Article.find_by_id(id)
    @article.menu_order.should  == @site.pages.count

  end


  it "previous order from 2 to 1" do
    @article = @site.pages.where('site_id = :site_id', :site_id => @site.id).
            offset(1).
            limit(1).
            order('menu_order').first
    id = @article.id
    @article.to_previous_menu_order
    @article = Article.find_by_id(id)
    @article.menu_order.should  == 1
  end

  it "previous order from last" do
    @article = @site.pages.last
                
    id = @article.id
    @article.to_previous_menu_order
    @article = Article.find_by_id(id)
    @article.menu_order.should  == @site.pages.count - 1
  end

  it "previous order from  1" do
    @article = @site.pages.first
    id = @article.id
    @article.to_previous_menu_order
    @article = Article.find_by_id(id)
    @article.menu_order.should  == 1
  end
  
  it "max menu order is set when create" do
    @article = @site.pages.create!(
      :name => 'teste', :title => 'test5', :content => '<p>content</p>',
      :site => @site, :user => @user
    )
    max_article = @site.pages.where('site_id = :site_id', :site_id => @site.id).
            offset(0).
            limit(1).
            order('menu_order desc').first
    max_article.id.should == @article.id    
  end

  it "updated month is selected" do
    months = PageArticle.updated_months(@site.id)
    months[0].to_s.should == PageArticle::Month.new(Time.now.year, Time.now.month).to_s
    article = @site.pages[0]
#    ActiveRecord::Base.record_timestamps = false
    Article.connection.execute("update articles set updated_at = '"  + 
            Time.now.years_ago(1).strftime("%Y-%m-%d") + "'" +
             " WHERE id = #{article.id}")
    months = PageArticle.updated_months(@site.id, 'asc')
    months[1].to_s.should == PageArticle::Month.new(Time.now.year, Time.now.month).to_s
    months[0].to_s.should == PageArticle::Month.new(Time.now.year - 1, Time.now.month).to_s

  end

  it "created month is selected" do
    months = PageArticle.created_months(@site.id)
    months[0].to_s.should == PageArticle::Month.new(Time.now.year, Time.now.month).to_s
    article = @site.pages[0]
#    ActiveRecord::Base.record_timestamps = false
    Article.connection.execute("update articles set created_at = '"  + 
            Time.now.years_ago(1).strftime("%Y-%m-%d") + "'" +
             " WHERE id = #{article.id}")
    months = PageArticle.created_months(@site.id, 'asc')
    months[1].to_s.should == PageArticle::Month.new(Time.now.year, Time.now.month).to_s
    months[0].to_s.should == PageArticle::Month.new(Time.now.year - 1, Time.now.month).to_s

  end
  
  it "error if over limited page count" do
    c = @site.pages.count
    Validator::Article::PageLimit.limit_value = c
    article = PageArticle.make_unsaved(:name => 'pagee')
    article.should_not be_valid
    #article.errors[:base].should_not == []

  end

  it "no error unless over limited page count" do
    c = @site.pages.count + 1
    Validator::Article::PageLimit.limit_value = c
    article = PageArticle.make(:name => 'pagee')
    article.should be_valid
#    article.errors[:base].should == []
  end

  
end
