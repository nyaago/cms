module Form
  
  require 'active_model'


  # = Form::Inquiry
  # 問い合わせフォームのモデル
  # SiteInquiryItem モデルのレコード配列の内容をもとに Form から送られた request パラメーターを
  # モデルレコードの属性にMappingする.
  # (item_<site inquiry item id> と属性名の属性にMappingされる )
  class Inquiry

    TRANSLATION_SCOPE = [:activemodel, :form, :attributes, :inquiry]    
#    include ActiveModel::AttributeMethods
    
    # model_name を実装してくれる。これがないと form_for できない  
    extend ActiveModel::Naming  
    # to_key などを実装してくれる。これがないと form_for できない  
    include ActiveModel::Conversion
    # Validation を可能にする.
    include ActiveModel::Validations
    # ActiveModel::Conversion を include するために必要  
    def persisted?  
      false  
    end
    
    # Emailアドレスの検証
    validates_with Form::Validator::Inquiry::Email
    # 必須入力の検証
    validates_with Form::Validator::Inquiry::Required
    
    # 初期化
    # == option parameters
    # * :params => request parameters (Hash)      
    # * :inquiry_items => Array of SiteInquiryItem model records
    def initialize(options)
      @attributes = {}
      self.params =  options[:params] || {}
      self.inquiry_items = options[:inquiry_items] || {}
      
    end
    
    # request parameters (Hash)
    # item_<site inquiry item id> の形式のparameterは,
    # このモデルのレコードの属性として設定する.
    def params=(params)
      @params = params
      @params.each do |attribute_name, value|
        @attributes[attribute_name] = value
      end
    end
    
    # Array of SiteInquiryItem model records
    def inquiry_items=(items)
      @inquiry_items = items
      @inquiry_items.each do |inquiry_item|
        attribute_name = "item_#{inquiry_item.id}"
        unless @attributes.include?(attribute_name)
          @attributes[attribute_name] = 
          if inquiry_item.inquiry_item.respond_to?(:default_value)
            inquiry_item.inquiry_item.send(:default_value)
          else
            ''
          end
        end
      end
    end
    
    # return Array of SiteInquiryItem model records
    def inquiry_items
      @inquiry_items
    end
  
    
    def attributes
      @attributes
    end
    
    def [] (attribute_name)
      @attributes[attribute_name]
    end
    
    # attribute名の配列を返す
    # == parameters 
    # * include_confirmation => 確認入力属性を含むか?. defaultはfalse
    def ordered_attribute_names(include_confirmation = false)
      names = []
      @inquiry_items.each do |site_inquiry_item|
        names << "item_#{site_inquiry_item.id}"
        if include_confirmation
          if site_inquiry_item.inquiry_item && 
              site_inquiry_item.inquiry_item.respond_to?(:confirmation_required)
            if site_inquiry_item.inquiry_item.send(:confirmation_required)
              names << "item_#{site_inquiry_item.id}_confirmation"
            end
          end
        end
      end
      names
    end
    
    def confirm_to_addresses
      addresses = []
      @inquiry_items.each do |inquiry_item|
        attribute_name = "item_#{inquiry_item.id}"
        if inquiry_item.inquiry_item.respond_to?(:confirm_to)
          if inquiry_item.inquiry_item.send(:confirm_to)
            unless @attributes[attribute_name].blank?
              addresses << @attributes[attribute_name]
            end
          end
        end
      end
      addresses
    end
  
    # 
    # item_<site inquiry item id> の形式の属性名に対する read/write のメソッド送信に応答.
    # ただし、inquiry_items属性に含まれている<site inquiry item id>のみへの応答となる
    def method_missing(name, *args)
      # method 名分解 -  
      # 1 => 属性名, 2 => site_inquiry_item_id, 3 => _confirmaton | '', 4 => '=' | ''
      matches = /^(item_([0-9]+)(_confirmation|))(=|){0,1}$/.match(name)
      if matches.nil?
        return super
      end
      attribute_name = matches[1]
      item_id = matches[2].to_i
      is_confirmation = matches[3] == '_confirmation'
      is_writer = matches[4] == '='
      # 属性あるか
      if item_id == 0
        return super
      end
      if @inquiry_items.index { |item| item.id == item_id  }.nil?
        return nil
      end
      if is_writer then
        if args.size == 0
          raise ArgumentError, "bad argument 0 for 1"
        end
        @attributes[attribute_name] = args[0]
      end
      if @attributes.include?(attribute_name) 
        @attributes[attribute_name]
      else
        nil
      end
    end
  
    # 属性の表示名称を返す
    # 属性名から('item_<site inquiry item id>' ) に含まれるidから
    # inquiry_item の title を得て、返す
    def self.human_attribute_name(attribute, options = {})
      matches = /^item_([0-9]+)(_confirmation|)$/.match(attribute)
      id = if matches then matches[1].to_i else nil end
      is_confirmation = matches[2] == '_confirmation'
      if id 
        site_inquiry_item = SiteInquiryItem.find_by_id(id)
        if site_inquiry_item && site_inquiry_item.inquiry_item &&
            site_inquiry_item.inquiry_item.respond_to?(:title)
          if site_inquiry_item.inquiry_item.title.blank? then 
            '' 
            else 
              site_inquiry_item.inquiry_item.title 
            end +
          if is_confirmation  
            I18n.t :confirmation, :scope => TRANSLATION_SCOPE
          else
            ''
          end
        else
          attribute
        end
      else
        attribute
      end
    end
  
    protected
  
    
  end
  
end
  