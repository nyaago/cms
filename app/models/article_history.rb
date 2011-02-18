# = ArticleHistory
# 記事履歴のモデル
class ArticleHistory < ActiveRecord::Base
  belongs_to :article, :readonly => true
end
