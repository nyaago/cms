module Layout

  # = Conig::Layout::Template
  # レイアウトテンプレートの設定を保持するモデル
  class Template < Layout::Base
    # template一覧設定ファイル(yaml)ファイルを配置するパス
    CONFIG_DIR = ::Rails.root.to_s + "/config/layouts/templates"
    
    # templateの名前
    attr_reader :name
    # templateの表示タイトル
    attr_reader :title
    
    # 初期化
    # nameとoptionsのマップを引数で含む
    # == Options
    # :title 
    def initialize(name,options)
      @name = name
      @title = options[:title] if options.include?(:title)
    end

    # 選択のためのサムネイルのファイルシステム上のパス
    def thumb_path
      ::Rails.root.to_s + "/public/templates/#{self.name}/thumb.jpg"
    end

    # 選択のためのサムネイルのurl
    def thumb_url
      "/templates/#{self.name}/thumb.jpg" 
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
      "templates"
    end

    # 一覧設定ファイル(yaml)ファイルを配置するパス
    def self.config_path
      self::CONFIG_DIR
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
                        end
                        )
    end

  end
end
