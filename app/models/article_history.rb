class ArticleHistory < ActiveRecord::Base
  belongs_to :article, :readonly => true
end
