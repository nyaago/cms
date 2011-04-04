require 'spec_helper'

SITE_ID = 1

describe Article do

  before  do 
    @site = Site.new(:name => 'moomin', :title => 'moomin')
    @user = User.new(:login => 'moomin', :email => 'nyaago69@gmail.com')
    @user.password = @user.password_confirmation = 'moomin'
    @user.is_site_admin = true
    @user.site = @site
    @user.save!
    @site.save!
    Article.create!(
      :name => 'testa', :title => 'test1', :content => '<p>content</p>',
      :type => "BlogArticle",
      :site => @site, :user => @user
    )
    Article.create!(
      :name => 'testb', :title => 'test2', :content => '<p>content</p>',
      :type => "BlogArticle",
      :site => @site, :user => @user
    )
    Article.create!(
      :name => 'testc', :title => 'test3', :content => '<p>content</p>',
      :type => "BlogArticle",
      :site => @site, :user => @user
    )
    Article.create!(
      :name => 'testd', :title => 'test4', :content => '<p>content</p>',
      :type => "BlogArticle",
      :site => @site, :user => @user
    )
  end

  it "next order" do
    @article = Article.where('site_id = :site_id', :site_id => @site.id).
            offset(1).
            limit(1).
            order('menu_order').first
    id = @article.id
    @article.to_next_menu_order
    @article = Article.find_by_id(id)
    @article.menu_order.should  == 3
  end

  it "previous order" do
    @article = Article.where('site_id = :site_id', :site_id => @site.id).
            offset(1).
            limit(1).
            order('menu_order').first
    id = @article.id
    @article.to_previous_menu_order
    @article = Article.find_by_id(id)
    @article.menu_order.should  == 1
  end
  
  it "max menu order is set when create" do
    @article = Article.create!(
      :name => 'teste', :title => 'test5', :content => '<p>content</p>',
      :article_type => 1,
      :site => @site, :user => @user
    )
    max_article = Article.where('site_id = :site_id', :site_id => @site.id).
            offset(0).
            limit(1).
            order('menu_order desc').first
    max_article.id.should == @article.id    
  end

  
  
end
