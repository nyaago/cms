module Layout
  
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