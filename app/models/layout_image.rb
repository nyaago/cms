# -*- coding: utf-8 -*-
# = LayoutImage
# Header, Footer, backgroud..等のレイアウト用画像データモデル
# == Attachmentオブジェクトへdelegateされるメソッド
# * url(style = default_style)
# * path(style = default_style)
class LayoutImage < ActiveRecord::Base
  
  # 翻訳リソースのスコープ
  TRANSLATION_SCOPE = ["errors", "layout_image", "messages"].freeze
  #
  IMAGE_CONTENT_TYPE = ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 
    'image/png', 'image/x-png'].freeze
  # 
  VALID_CONTENT_TYPE = IMAGE_CONTENT_TYPE

#  require 'rubygems'
#  require 'RMagick'

  belongs_to :site
  belongs_to :article
  belongs_to :user, :readonly => true, :foreign_key => :updated_by

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


  # Paperclip, アップロード設定
   has_attached_file :image,
      :default_style => :original,
      :path => ":rails_root/public/layout-images/:id/:basename.:extension",
      :url => "/layout-images/:id/:basename.:extension",
      :whiny => false

  # 拡張子の制限
  validates_attachment_content_type :image,
    :content_type => VALID_CONTENT_TYPE,
    :message => I18n.t(:attachment_content_type, :scope => TRANSLATION_SCOPE)

  # ファイルサイズ制限
  validates_attachment_size :image,
    :less_than => 2.megabytes,
    :message => I18n.t(:attachment_size, :scope => TRANSLATION_SCOPE)


  protected

end
