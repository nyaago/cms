class File

  # 拡張子の取得.
  # 日本語が含まれている場合エラーとなるため再定義
  def self.extname(name)
     return $1 if /\.([a-zA-Z0-9]+?)$/ =~ name
     ""
  end
end
