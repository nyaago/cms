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

    extend StaticMethods

    # themeの名前
    attr_reader :name
    # themeの表示タイトル
    attr_accessor :human_name

    # 初期化
    # nameを指定して初期化
    def initialize(name)
      @name = name
    end


    
    def self.attribute_name
      self.name.demodulize.underscore
    end
    
    # スタイルシートのパス
    def self.css_path(name, theme = nil)
      theme_parts = if theme then "themes/#{theme}/stylesheets/" else '' end
      ::Rails.root.to_s + 
      "/public/#{theme_parts}#{self.name.demodulize.underscore.pluralize}/#{name}/" + 
        "#{self.name.demodulize.underscore}.css"
    end
    # スタイルシートのパス
    def self.css_url(name, theme = nil)
      if theme 
        theme_parts = if theme then "themes/#{theme}/stylesheets/" else '' end
        "/#{theme_parts}#{self.name.demodulize.underscore.pluralize}/#{name}/" + 
          "#{self.name.demodulize.underscore}.css"
      else
        "/#{self.name.demodulize.underscore.pluralize}/#{name}/" + 
          "#{self.name.demodulize.underscore}.css"
      end
    end

    
    # cssの内容取得
    def self.css_content(name)
      if File.file?(css_path(name))
        File.open(css_path(name)) do |file|
          file.read
        end
      else
        ''
      end
    end
    
    ##### instance method #######

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
    
  end
  
end
