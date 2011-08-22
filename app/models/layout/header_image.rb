module Layout

  # = Layout::HeaderImage
  # preset されている ヘッダー画像エントリー設定を保持するモデル
  class HeaderImage < Layout::Base

    # 選択のためのサムネイルのurl
    def thumb_url
      "/#{self.class.name.demodulize.underscore.pluralize}/#{self.name}-thumbnail.jpg" 
    end

    # 表示画像ののurl
    def image_url
      "/#{self.class.name.demodulize.underscore.pluralize}/#{self.name}.jpg" 
    end

    # 設定名を指定しての表示画像ののurl
    # == parameters
    # * name header_image.yml - header_images の配列要素.name要素で設定した名前
    def self.image_url(name)
      "/#{self.name.demodulize.underscore.pluralize}/#{name}.jpg" 
    end

  end

end
