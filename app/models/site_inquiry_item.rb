# = SiteInquiryItems
# サイト - 問い合わせ項目定義関連のモデル
class SiteInquiryItem < ActiveRecord::Base
  
  # サイトとの関連
  belongs_to :site
  # 変更操作ユーザとの関連
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  
  # タイプ別のinquiry_itemへの関連
  belongs_to :inquiry_item, :polymorphic => true
  
  # 表示位置の調整
  # target　レコードに設定されているposition　に併せて、他のレコードのpositionを調整する
  def adjust_positions
    if self.position.blank? || self.position.zero? #　一番最後..
      last_site_inquiry_item = self.site.site_inquiry_items.
                                          select('max(position) as max_position').
                                          first
      self.position = if last_site_inquiry_item.nil?
        1
      else
        last_site_inquiry_item.max_position + 1
      end
      self.save(:validate => false)
    else
      pos = self.position + 1
      self.site.site_inquiry_items.
                select('id, position').
                where('position >= :position', :position => self.position).
                where('id <> :id', :id => self.id).
                order('position').each do |site_inquiry_item|
        site_inquiry_item.position = pos
        site_inquiry_item.save!(:validate => false)
        pos += 1
      end
    end
  end
  
  # Inquiry Item の 並び変え
  # == parameters
  # * site - サイトモデルのレコード
  # * ordered - 更新すべき並び順に格納されている site_inquiry_item の id の配列.
  def self.sort_with_ordered(site, ordered)
    site.site_inquiry_items.select('id, position').each do |site_inquiry_item|
      if ordered.include?(site_inquiry_item.id)
        site_inquiry_item.position = ordered.index(site_inquiry_item.id) + 1
        site_inquiry_item.save!(:validate => false)
      end
    end
  end
  
end
