site = Site.create(:name => 'moomin', :title => 'moomin')
user = User.new(:login => 'moomin', :email => 'nyaago69@gmail.com')
user.password = user.password_confirmation = 'moomin'
user.site = site
user.save!