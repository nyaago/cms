# = SiteWidget
# サイトとWidgetの対応
class SiteWidget < ActiveRecord::Base
  
  # 
  belongs_to :site
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  
  # タイプ別のwidgetへの関連
  belongs_to :widget, :polymorphic => true
  
  
  # 表示位置の調整
  # target　レコードに設定されているposition　に併せて、他のレコードのpositionを調整する
  def adjust_positions
    if self.position.blank? || self.position.zero? #　一番最後..
      last_site_widget = self.site.site_widgets.select('max(position) as max_position').
                                                where('area = :area', :area => self.area).
                                                first
      self.position = if last_site_widget.nil?
        1
      else
        last_site_widget.max_position + 1
      end
      self.save(:validate => false)
    else
      pos = self.position + 1
      self.site.site_widgets.
                select('id, position').
                where('area = :area', :area => self.area).
                where('position >= :position', :position => self.position).
                where('id <> :id', :id => self.id).
                order('position').each do |site_widget|
        site_widget.position = pos
        site_widget.save!(:validate => false)
        pos += 1
      end
    end
  end
  
  # Widget の 並び変え
  # == parameters
  # * site - サイトモデルのレコード
  # * area - Widget のエリア. side | footer
  # * ordered - 更新すべき並び順に格納されている site_widget の id の配列.
  def self.sort_with_ordered(site, area, ordered)
    site.site_widgets.select('id, position').
        where("area = :area", :area => area).each do |site_widget|
      if ordered.include?(site_widget.id)
        site_widget.position = ordered.index(site_widget.id) + 1
        site_widget.save!(:validate => false)
      end
    end
  end
  
end
