# -*- coding: utf-8 -*-

class String
  
  # 前後の全角を含む空白文字の除去
  def strip_with_full_size_space!
    self.gsub!(/^[　\s\t]+/o, "")
    self.gsub!(/[　\s\t]+$/o, "")
  end
  
  # 前後の全角を含む空白文字の除去
  def strip_with_full_size_space
    self.gsub(/[　\s\t]+$/o, "").gsub(/^[　\s\t]+/o, "")
  end
  
end
