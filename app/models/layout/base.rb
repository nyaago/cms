module Layout

  # = Conig::Layout::Base
  # レイアウトの設定を保持するモデルのベース
  # == 共通のクラスMethod
  # * self.load
  # == 共通のインスタンスMethod
  # * == () - 同値比較.名前による比較
  # == load されたコレクション(Array)に追加されるmethod
  # * find_by_name - 名前を指定して要素を返す
  class Base

    # themeの名前
    attr_reader :name
    # themeの表示タイトル
    attr_accessor :human_name

    # 初期化
    # nameを指定して初期化
    def initialize(name)
      @name = name
    end


    # 設定yamlファイルを読み込み,
    # config_path属性がディレクトリーならそのディレクトリー内のymlファイルを全て,
    # 通常ファイルであればそのファイルを読み込む.
    # 結果として,modelのarrayを生成する.
    def self.load
      models = []
      
      # file一覧を取得
      files = 
      if File.directory?(config_path) 
        files_in_dir = []
        Dir[config_path + "/*.yml"].each do |file|
          files_in_dir << file
        end
        files_in_dir
      elsif File.file?(config_path)
        [config_path]
      else
        nil
      end
      
      return nil if files.nil?

      # ファイルを読み込み,モデルの配列を生成
      files.each do |file|
        begin
          yaml = YAML.load_file(file)
        rescue  => ex
          logger.debug "failed in reading yaml (#{file})"
          next
        end
        if yaml.nil?
          logger.debug "failed in reading yaml (#{file})"
          next
        end
        models += self.yaml2models(yaml)
      end
      
      # モデルの配列(Array)への特異method追加
      models.extend(ArrayMethods)
      
      models
    end

    # 同値比較.
    # nameが同じであれば同値と判定
    def == (other)
      self.name == other.name
    end
    
    def inspect
      "#{self.class.name.demodulize.underscore} " + super
    end
    
    def to_s
      name
    end
    
    # 選択のためのサムネイルのファイルシステム上のパス
    def thumb_path
      ::Rails.root.to_s + 
      "/public/#{self.class.name.demodulize.underscore.pluralize}/#{self.name}/thumb.jpg"
    end

    # 選択のためのサムネイルのurl
    def thumb_url
      "/#{self.class.name.demodulize.underscore.pluralize}/#{self.name}/thumb.jpg" 
    end

    # スタイルシートのパス
    def css_path
      ::Rails.root.to_s + 
      "/public/#{self.class.name.demodulize.underscore.pluralize}/#{self.name}/" + 
        "#{self.class.name.demodulize.underscore}.css"
    end
    
    # cssの内容取得
    def css_content
      if File.file?(css_path)
        File.open(css_path) do |file|
          file.read
        end
      else
        ''
      end
    end
    
    protected
  
    # 一覧設定ファイル(yaml)ファイルを配置するパス
    def self.config_path
      ::Rails.root.to_s + "/config/layouts/#{name.demodulize.underscore}.yml"
    end
  
  
    # yamlのrootの要素名を返す
    def self.element_root
      name.demodulize.underscore.pluralize
    end
    
    # map(Hash)からモデルを生成して返す.生成できなければnil.
    # mapには'name'が含まれることが必須.Optionは'human_name'
    def self.map_to_model(map)
      return nil if map['name'].nil?

      model = self.new(map['name'])
      
      # option属性設定
      map.each_pair do |key, value|
        if key != 'name' && model.respond_to?("#{key}=".to_sym)
          model.send("#{key}=".to_sym, value)
        end
      end
      model                  
        
    end
  
    # yamlの読み込み結果からmodelのarrayを生成.
    def self.yaml2models(yaml)
      return [] if yaml[self.element_root].nil?

      if yaml[self.element_root].respond_to?(:each_index)
        result = []
        yaml[self.element_root].each do |elem|
          model = self.map_to_model(elem)
          result << model unless model.nil?
        end
        result
      elsif yaml[self.element_root].respond_to?(:each_key)
        model = self.map_to_model(yaml[self.element_root])
        if model.nil?
          []
        else
          [model]
        end
      else
        []
      end
    end

    # loggerを返す
    def self.logger
      require 'logger'
      rails_env = unless ENV['RAILS_ENV'].blank? 
        ENV['RAILS_ENV']
      else
        "development"
      end
      Logger.new(::Rails.root.to_s + "/log/#{rails_env}.log")
    end
  
  end


  # モデルのload method　で返される arrayインスタンスに追加する特異メソッドを定義
  module ArrayMethods
    
    # 名前から要素を返す
    def find_by_name(name)
      return nil if self.size == 0
      model = self[0].class.new(name)
      if self.include?(model)
        self[self.find_index(model)]
      else
        nil
      end
    end

    # defaultの要素を返す
    def find_default
      return nil if self.size == 0
      model = self[0].class.new('default')
      if self.include?(model)
        self[self.find_index(model)]
      else
        self[0]
      end
    end

  end
  
end
