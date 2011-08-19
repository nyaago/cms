module Layout

  # = Layout::Thema
  # テーマの設定を保持するモデル
  class Theme < Layout::Base
    # theme一覧設定ファイル(yaml)ファイルを配置するパス
    CONFIG_DIR = ::Rails.root.to_s + "/config/layouts/themes"
    
    # themeの説明
    attr_accessor :description, :order

    def description
      if @description.nil? then '' else @description end
    end
    
    def order
      if @order.nil? then 0 else @order.to_i end
    end

    protected
    
    # 一覧設定ファイル(yaml)ファイルを配置するパス
    def self.config_path
      CONFIG_DIR
    end

  end
  
end
