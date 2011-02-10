class SiteLayout < ActiveRecord::Base
  belongs_to :site
  
  # 作成時のFilter. default値の設定
  before_create :set_default
  
  # 各属性値を参照してのcssを生成.css属性に設定する.
  # formatに関する属性については.そのformatの属性への値設定
  before_update :set_css_and_format
  
  # default値の設定
  def set_default
    self.theme = 'default'
    self.eye_catch_type = 'none'
    self.font_size = 'default'
    self.skin_color = 'default'
    self.column_layout = 'menu_on_left'
    self.global_navigation = 'home_link'
  end

  # 各属性値を参照してのcssを生成.css属性に設定する.
  # formatに関する属性については.そのformatの属性への値設定
  #   (現行では,title_tag属性の値に対応するtitle_tag_format属性への値設定)
  def set_css_and_format
    css = ""
    defs = Layout::DefinitionArrays.new
    ["eye_catch_type", "skin_color", "font_size", "column_layout", "global_navigation"].
    each do |attr_name|
      attr_array = defs.send(attr_name.pluralize)
      selected_attr = attr_array.find_by_name(self.send(attr_name))
      selected_attr = attr_array.find_default if selected_attr.nil? 
      css << "/*#{attr_name} = #{selected_attr.name}*/ \n" + 
            "#{selected_attr.css_content} \n"
    end
    self.css = css
    ["title_tag"].
    each do |attr_name|
      attr_array = defs.send(attr_name.pluralize)
      selected_attr = attr_array.find_by_name(self.send(attr_name))
      selected_attr = attr_array.find_default if selected_attr.nil? 
      self.send(attr_name + "_format=", selected_attr.format)
    end

  end
  
end
