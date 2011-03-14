# = ArticleHistory
# 記事履歴のモデル
class ArticleHistory < ActiveRecord::Base
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  belongs_to :site, :readonly => true
  belongs_to :article, :readonly => true
end
