require 'spec_helper'

SITE_ID = 1

describe Article do

  before  do 

    @site = Site.all.first
    @site2 = Site.all[1]
    @user = User.all.first

    PageArticle.destroy_all('site_id' => @site.id)
    
    # 記事
    a = PageArticle.make(:name => 'pagea', :is_home => true)
    b = PageArticle.make(:name => 'pageb')
    c = PageArticle.make(:name => 'pagec')
    d = PageArticle.make(:name => 'paged')

    PageArticle.make(:name => 'pagea', :is_home => true, :site_id => @site2.id)
    PageArticle.make(:name => 'pageb', :site_id => @site2.id)
    PageArticle.make(:name => 'pagec', :site_id => @site2.id)
    PageArticle.make(:name => 'paged', :site_id => @site2.id)


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
  
  it "published_if_require_before" do
    article = @site.pages[0]
    article.published = false
    article.published_from = Time.now.ago(60)
    article.save!(:validate => false)
    id = article.id
    article = @site.pages.where("id = :id", :id => id).first
    article.published_if_require_before.should == true
  end

  it "no published_unless_require_before" do
    article = @site.pages[0]
    article.published = false
    article.published_from = Time.now.tomorrow
    article.save!(:validate => false)
    id = article.id
    article = @site.pages.where("id = :id", :id => id).first
    article.published_if_require_before.should == false
  end
  
  it "cancel_is_home_except_self" do 
    article = @site.pages.where("name = :name", :name => "pagea").first
    article.is_home.should == true
    article = @site.pages.where("name = :name", :name => "pageb").first
    article.is_home = true
    article.save!(:validate => false)
    article = @site.pages.where("name = :name", :name => "pagea").first
    article.is_home.should == false
  end
  
  it "check published (unpublished if published from future time)" do
    article = @site.pages[0]
    id = article.id
    article.published = true
    article.published_from = nil
    article.save!(:validate => false)
    article = Article.find_by_id(id)
    article.published.should == true
    article.published_from = Time.now.tomorrow
    article.save!(:validate => true)
    article = Article.find_by_id(id)
    article.published.should_not ==  true
  end
  
  
end
