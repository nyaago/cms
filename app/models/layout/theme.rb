module Layout

  # = Layout::Thema
  # テーマの設定を保持するモデル
  class Theme < Layout::Base
    # theme一覧設定ファイル(yaml)ファイルを配置するパス
    CONFIG_DIR = ::Rails.root.to_s + "/config/layouts/themes"
    
    # themeの名前
    attr_reader :name
    # themeの表示タイトル
    attr_reader :title
    # themeの説明
    attr_reader :description
    
    # 初期化
    # nameとoptionsのマップを引数で含む
    # == Options
    # :title 
    def initialize(name,options = {})
      @name = name
      @title = options[:title] if options.include?(:title) 
      @description = options[:description] if options.include?(:description) 
    end
    
    # 選択のためのサムネイルのファイルシステム上のパス
    def thumb_path
      ::Rails.root.to_s + "/public/themes/#{self.name}/thumb.jpg"
    end

    # 選択のためのサムネイルのurl
    def thumb_url
      "/themes/#{self.name}/thumb.jpg" 
    end
    
    def inspect
      "name => #{name}, title => #{title}"
    end
    
    def to_s
      name
    end
    

    protected
    
    # yamlのrootの要素名を返す
    def self.element_root
      "themes"
    end

    # 一覧設定ファイル(yaml)ファイルを配置するパス
    def self.config_path
      CONFIG_DIR
    end

    # map(Hash)からモデルを生成して返す.生成できなければnil.
    # mapには'name'が含まれることが必須.Optionは'title'
    def self.map_to_model(map)
      return nil if map['name'].nil?

      self.new(map['name'], 
              :title => if map['title'].nil? 
                          map['name']
                        else
                          map['title']
                        end,
              :description => if map['description'].nil? 
                          ''
                        else
                          map['description']
                        end
                        )
                        
    end

  end
end
