# -*- coding: utf-8 -*-
# = Image
# 画像データモデル
# == Attachmentオブジェクトへdelegateされるメソッド
# * url(style = default_style)
# * path(style = default_style)
class Image < ActiveRecord::Base

  belongs_to :site
  belongs_to :user, :readonly => true, :foreign_key => :updated_by
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["errors", "image", "messages"].freeze
  #
  IMAGE_CONTENT_TYPE = ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
  # 
  VALID_CONTENT_TYPE = IMAGE_CONTENT_TYPE + 
                      ['application/pdf', 
                      'application/vnd.ms-excel', 'application/msword', 'application/vnd.ms-powerpoint']
  #
  STYLES = [:original, :medium, :small, :thumb]

#  require 'rubygems'
#  require 'RMagick'


  # 保存前のcallback
  # 各属性の不要な前後空白をぬく
  before_save :strip_attributes

  # Returns the public URL of the attachment, with a given style. Note that
  # this does not necessarily need to point to a file that your web server
  # can access and can point to an action in your app, if you need fine
  # grained security.  This is not recommended if you don't need the
  # security, however, for performance reasons. Set use_timestamp to false
  # if you want to stop the attachment update time appended to the url
  # style_name => :mediumu, :small, :thumb, :original, 
  # default_style_nameはoriginal
  def url(style_name = attachment_for(:image).default_style)
    attachment_for(:image).url(style_name)
  end
  
  # Returns the path of the attachment as defined by the :path option. If the
  # file is stored in the filesystem the path refers to the path of the file
  # on disk. 
  # style_name => :mediumu, :small, :thumb, :original, 
  # default_style_nameはoriginal
  def path style_name = attachment_for(:image).default_style
    attachment_for(:image).path(style_name)
  end
  
  # 指定したStyleのファイルがあるか?
  def exist?  style_name = attachment_for(:image).default_style
    File.file?(path(style_name)) if !path(style_name).blank?
  end

  # 全てのStyleのファイルが存在するか?
  def exist_all_style?
    result = true
    STYLES.each do |style|
      if !exist?(style) 
        result = false
        break
      end
    end
    result
  end

  # 画像データであるか?
  def image_content_type?
    IMAGE_CONTENT_TYPE.include?(image_content_type)
  end

  # 年月での絞り込み
  def self.filter_by_month(cur_month, site_id = nil)
    return Image.where(nil)  if cur_month.blank?
    Image.where("  DATE_FORMAT(created_at, '%Y%m') = :ym" ,
                  :ym =>    cur_month
                  )
  end

  # 年月を保持するオブジェクト
  class Month
    
    attr_reader :year, :month
    
    def initialize(year, month)
      @year = year
      @month = month
      @datetime = DateTime.new(year, month)
    end
    
    def to_s(format = '%Y-%m')
      @datetime.strftime(format)
    end
  end

  # 存在する作成年月の一覧を返す
  # == Parameter
  # * site_id - site id.nilだだと全て
  # * direction - ソート方向(desc/asc).defaultはdesc
  def self.created_months(site_id = nil, direction = 'desc')
    months = Image.select("DATE_FORMAT(created_at, '%Y%m') as ym").
                      where(if site_id then 'site_id = :site_id' else nil end,
                      :site_id => site_id ).
                      group('ym').
                      order("ym #{direction}")
    result = []
    months.each do |month|
      elem = Month.new(month.ym[0..3].to_i, month.ym[4..5].to_i)
      result << elem
    end
    result
  end

  # 存在する更新年月の一覧を返す
  # == Parameter
  # * site_id - site id.nilだだと全て
  # * direction - ソート方向(desc/asc).defaultはdesc
  def self.updated_months(site_id = nil,direction = 'desc')
    months = Image.select("DATE_FORMAT(updated_at, '%Y%m') as ym").
                      where(if site_id then 'site_id = :site_id' else nil end,
                      :site_id => site_id ).
                      group('ym').
                      order("ym #{direction}")
    result = []
    months.each do |month|
      elem = Month.new(month.ym[0..3].to_i, month.ym[4..5].to_i)
      result << elem
    end
    result
  end

  # Paperclip, アップロード設定
   has_attached_file :image,
     :styles => {
       :medium=> "250x250>",  # リサイズ
       :small=> "160x160>",  # リサイズ
       :thumb => "100x100#"  # トリミング
      },
      :default_style => :original,
      :path => ":rails_root/public/user-images/:id/:style_:basename.:extension",
      :url => "/user-images/:id/:style_:basename.:extension",
      :whiny => false

  # 拡張子の制限
  validates_attachment_content_type :image,
    :content_type => VALID_CONTENT_TYPE,
    :message => I18n.t(:attachment_content_type, :scope => TRANSLATION_SCOPE)

  # ファイルサイズ制限
  validates_attachment_size :image,
    :less_than => 3.megabytes,
    :message => I18n.t(:attachment_size, :scope => TRANSLATION_SCOPE)

  # ファイルの合計サイズを返す
  def size
    s = 0
    STYLES.each do |style|
      s += if exist?(style) then File.size(path(style)) else 0 end
    end
    s
  end

#  alias_method :save_attached_files_without_calculation, :save_attached_files

#  def save_attached_files
##    save_attached_files_without_calculation
#    set_calculated_attributes
#    self.save!(:validate => false)
#    false
#  end
  
  # 保存後フィルター.画像のトータルサイズと画像区分フラグを計算して保存
  # Paperclipのafter_save より後に実行される必要があるので、
  # ここ（Paperclipをincludeするコードより後）に指定.
  after_save :set_calculated_attributes

  protected
  
  # 画像のトータルサイズと画像区分フラグを計算して保存
  def set_calculated_attributes
    return true unless self.changed?
    return true if (size = self.size) == self.total_size
    self.total_size = size
    self.is_image =  self.image_content_type?
    self.save!(:validate => false)
    true
  end

  # 各属性の不要な前後空白をぬく
  def strip_attributes
    begin
      if self.respond_to?(:title) 
        title.strip_with_full_size_space! unless title.nil?  
      end
    rescue
    end
    begin
      if self.respond_to?(:meta_description) 
        alternative.strip_with_full_size_space! unless alternative.nil? 
      end
    rescue
    end
    begin
      if self.respond_to?(:meta_keywords) 
        caption.strip_with_full_size_space! unless caption.nil?
      end
    rescue
    end
    true
  end

end
