# = 毎時間ごとに実行すべき タスク
# crontab 設定例 =>
# 1 * * * * <home>/.rvm/gems/ruby-1.9.2-p136/bin/rails runner <app>/runners/runner_by_hour.rb
# == 実行タスク
# * 解約予約日時が過ぎていれば解約
# * 公開予定日時の過ぎている記事を公開
# * temporary の 記事を削除

# 解約予約日時が過ぎていれば、解約
def cancel_if_reserved_before(site)

  if site.cancel_if_reserved_before
    site.save!(:validate => false)
  end
end

# 投稿記事の公開予約日時が過ぎていれば、公開
def published_if_require_before(site)
  site.articles.
      where("(published = false or published is null)").
      where("published_from IS NOT NULL").
      where("published_from < NOW()").    # mysql 固有
        each do |article|
    if article.published_if_require_before
      article.save!(:validate => false)
    end
  end
end

Site.all.each do |site|

  begin 
    cancel_if_reserved_before(site)
    published_if_require_before(site)
  rescue => ex
    p ex.message
    p ex.backtrace
    p "error site = #{site.name}"
  end
  
end

# 更新日時が1日以上前のpreview 用temporary 記事 を削除
Article.remove_temporaries

