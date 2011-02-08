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

    # 一覧設定ディレクトリ内のyamlファイルを読み込み,
    # modelのarrayを生成する.
    def self.load
      models = []
      Dir[config_path + "/*.yml"].each do |file|
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
      
      # 名前から要素を返す
      def models.find_by_name(name)
        return nil if self.size == 0
        model = self[0].class.new(name)
        if self.include?(model)
          self[self.find_index(model)]
        else
          nil
        end
      end
      
      models
    end

    # 同値比較.
    # nameが同じであれば同値と判定
    def == (other)
      self.name == other.name
    end
    
    
    protected
  
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
  
end
