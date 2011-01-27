class Site < ActiveRecord::Base
  
  has_many :articles, :dependent => :destroy
  has_many :users, :dependent => :destroy
  
end
