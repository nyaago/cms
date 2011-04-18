module Layout

  # = Conig::Layout::Widget
  # Widgetの
  class Widget

    extend StaticMethods

    # widgetの名前
    attr_reader :name

    # 説明
    attr_accessor :description


    # 初期化
    # nameを指定して初期化
    def initialize(name)
      @name = name
    end

    ##### instance method #######

    # 対応するモデルクラス名を返す
    def class_name
      @name.camelize
    end

    # 対応するモデルクラスオブジェクトを返す
    def clazz
      class_name.split(/::/).inject(Object) {|c,name| c.const_get(name) }
    end

    # 表示名称
    def human_name
      clazz.human_name
    end

    # 編集を行うcontroller クラス名
    def controller_class_name
      "SiteAdmin::#{@name.camelize}"
    end
    
    # 編集を行うcontroller クラスオブジェクトを返す
    def controller_clazz
      controller_class_name.split(/::/).inject(Object) {|c,name| c.const_get(name) }
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
    
  end
  
end