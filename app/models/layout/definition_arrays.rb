module Layout

  # = Layout::DefinitionArrays
  # 各レイアウト定義の配列を保持する
  class DefinitionArrays 

    # レイアウトモデルクラス名一覧
    LAYOUT_CLASSES = [Layout::EyeCatchType, 
                        Layout::ColumnLayout, 
                        Layout::FontSize, 
                        Layout::GlobalNavigation, 
                        Layout::SkinColor, 
                        Layout::TitleTag]

    # 各レイアウト定義のArrayを格納する読み込み属性(reader属性)を生成
    # 以下の属性を生成.
    # * eye_catches
    # * column_layouts
    # * font_sizes
    # * global_navigations
    # * skin_colors
    # * title_tags
    LAYOUT_CLASSES.each do |clazz|
      attr_reader clazz.name.split('::').last.underscore.pluralize
    end

    # 初期化
    # 各レイアウト定義を読み込み,このオブジェクトのインスタンス属性に設定していく
    def initialize
      LAYOUT_CLASSES.each do |clazz|
        self.instance_variable_set(
        "@#{clazz.name.split('::').last.underscore.pluralize}".to_sym,
        clazz.load)
      end
    end

  end
  
end
