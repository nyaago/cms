class Page < ActiveRecord::Base
  belongs_to :site, :readonly => true
end
