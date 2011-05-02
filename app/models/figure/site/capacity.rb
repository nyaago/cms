module Figure
  
  module Site
  
    # サイトの容量に関する計算値を提供
    # siteモデルにincludeする
    module Capacity

      # 画像モデルへの関連名とそのモデルの画像サイズ属性名
      @@relation_and_size_attr_for_images = {:images => :total_size, 
                                            :layout_images => :image_file_size}.freeze
    
      # 使用済み容量を返す.
      def used_capacity
        result = 0
        @@relation_and_size_attr_for_images.each do |relation, attribute|
          result += self.send(relation).sum(attribute)
        end
        result
      end
    
      # レイアウト用画像の使用容量を返す.
      def used_capacity_for_site_layout
        self.layout_images.where("article_id IS NULL").sum("image_file_size")
      end
      
    
    end
    
  end
  
end