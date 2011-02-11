module Layout

  # = Layout::EyeCatchType
  # eye catch typeの設定を保持するモデル
  class EyeCatchType < Layout::Base
   
    # 配置場所(header or container or contents)
    attr_accessor :location
    
  end
end
