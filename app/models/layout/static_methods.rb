module Layout

  # = Conig::Layout::StaticMethods
  # レイアウト Config関連の static method を定義
  module StaticMethods
    
    # 設定yamlファイルを読み込み,
    # config_path属性がディレクトリーならそのディレクトリー内のymlファイルを全て,
    # 通常ファイルであればそのファイルを読み込む.
    # 結果として,modelのarrayを生成する.
    def load
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
        models += yaml2models(yaml)
      end
      
      # モデルの配列(Array)への特異method追加
      models.extend(ArrayMethods)
      
      models
    end
    
    protected
  
    # 一覧設定ファイル(yaml)ファイルを配置するパス
    def config_path
      ::Rails.root.to_s + "/config/layouts/#{name.demodulize.underscore}.yml"
    end
  
  
    # yamlのrootの要素名を返す
    def element_root
      name.demodulize.underscore.pluralize
    end
    
    # map(Hash)からモデルを生成して返す.生成できなければnil.
    # mapには'name'が含まれることが必須.Optionは'human_name'
    def map_to_model(map)
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
    def yaml2models(yaml)
      return [] if yaml[element_root].nil?

      if yaml[element_root].respond_to?(:each_index)
        result = []
        yaml[element_root].each do |elem|
          model = map_to_model(elem)
          result << model unless model.nil?
        end
        result
      elsif yaml[element_root].respond_to?(:each_key)
        model = map_to_model(yaml[element_root])
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
    def logger
      require 'logger'
      rails_env = unless ENV['RAILS_ENV'].blank? 
        ENV['RAILS_ENV']
      else
        "development"
      end
      Logger.new(::Rails.root.to_s + "/log/#{rails_env}.log")
    end
   
    
  end
  
end