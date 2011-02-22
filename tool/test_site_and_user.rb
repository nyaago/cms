site = Site.create(:name => 'moomin', :title => 'moomin', :email => 'nyaago69@gmail.com')
user = User.new(:login => 'moomin', :email => 'nyaago69@gmail.com')
user.password = user.password_confirmation = 'moomin'
user.site = site
user.save!

site = Site.create(:name => 'wasabi', :title => 'wasabi', :email => 'miki@wasabi3.com')
user = User.new(:login => 'wasabi', :email => 'miki@wasabi3.com')
user.password = user.password_confirmation = 'wasabi'
user.site = site
user.save!