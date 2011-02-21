# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Cms::Application.initialize!



ret = require File.expand_path('../../lib/time', __FILE__)
