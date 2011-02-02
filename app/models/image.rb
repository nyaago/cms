# -*- coding: utf-8 -*-
# = Image
# 画像データモデル
# == Attachmentオブジェクトへdelegateされるメソッド
# * url(style = default_style)
# * path(style = default_style)
class Image < ActiveRecord::Base

  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["messages", "site", "image"].freeze
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
  
  def exist?  style_name = attachment_for(:image).default_style
    File.file?(path(style_name))
  end

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
    :less_than => 2.megabytes,
    :message => I18n.t(:attachment_size, :scope => TRANSLATION_SCOPE)

  # ファイルの合計サイズを返す
  def size
    s = 0
    STYLES.each do |style|
      s += if exist?(style) then File.size(path(style)) else 0 end
    end
    s
  end

  protected
  

end
