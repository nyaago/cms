require 'spec_helper'

SITE_ID = 1

describe BlogArticle do

  before  do 
    @site = Site.all.first
    @user = User.all.first

    BlogArticle.destroy_all('site_id' => @site.id)
    
    # 記事
    a = BlogArticle.make(:name => 'bloga')
    b = BlogArticle.make(:name => 'blogb')
    c = BlogArticle.make(:name => 'blogc')
    d = BlogArticle.make(:name => 'blogd')

    # temporary 記事
    t = BlogArticle.new
    t.attributes = a.attributes
    t.parent_id = a.id
    t.is_temporary = true
    t.save!(:validate => false)
    t = BlogArticle.new
    t.attributes = c.attributes
    t.parent_id = c.id
    t.is_temporary = true
    t.save!(:validate => false)
    
  end


  it "updated month is selected" do
    months = BlogArticle.updated_months(@site.id)
    months[0].to_s.should == BlogArticle::Month.new(Time.now.year, Time.now.month).to_s
    article = @site.blogs[0]
#    ActiveRecord::Base.record_timestamps = false
    Article.connection.execute("update articles set updated_at = '"  + 
            Time.now.years_ago(1).strftime("%Y-%m-%d") + "'" +
             " WHERE id = #{article.id}")
    months = BlogArticle.updated_months(@site.id, 'asc')
    months[1].to_s.should == BlogArticle::Month.new(Time.now.year, Time.now.month).to_s
    months[0].to_s.should == BlogArticle::Month.new(Time.now.year - 1, Time.now.month).to_s

  end
  
  it "created month is selected" do
    months = BlogArticle.created_months(@site.id)
    months[0].to_s.should == BlogArticle::Month.new(Time.now.year, Time.now.month).to_s
    article = @site.blogs[0]
#    ActiveRecord::Base.record_timestamps = false
    Article.connection.execute("update articles set created_at = '"  + 
            Time.now.years_ago(1).strftime("%Y-%m-%d") + "'" +
             " WHERE id = #{article.id}")
    months = BlogArticle.created_months(@site.id, 'asc')
    months[1].to_s.should == BlogArticle::Month.new(Time.now.year, Time.now.month).to_s
    months[0].to_s.should == BlogArticle::Month.new(Time.now.year - 1, Time.now.month).to_s

  end


  
end
