module Layout

  # = Conig::Layout::Base
  # レイアウトの設定を保持するモデルのベース
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
      models
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
