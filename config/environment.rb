# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Cms::Application.initialize!


require "string"
require "site_admin/base_widget_controller"
require "site_admin/base_inquiry_item_controller"

#ret = require File.expand_path('../../lib/time', __FILE__)
