# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

site = Site.create(:name => 'wasabi', :title => 'wasabi', :email => 'miki@wasabi3.com')
user = User.new(:login => 'wasabi', :email => 'miki@wasabi3.com', :is_site_admin => true)
user.password = user.password_confirmation = 'wasabi'
user.site = site
user.save!

user = User.new(:login => 'admin', :password => 'admin', :password_confirmation => 'admin', :email => 'nyaago@bf.wakwak.com', :is_admin => true)
user.save!