# = Validator::Email
# Email アドレスのvalidator
# == ローカル部で可能な文字
# * 大小のラテン文字
# * 全角日本語
# * 数字
# * ! # $ % & ' * + - / = ? ^ _ ` { | } ~
# * .  ただし、先頭と末尾以外で使用可能。　[2個以上連続してはならない]については未検証
# == ドメイン部で可能な文字
# ラテン文字・数字・“-”（先頭はラテン文字または数字）
class EmailValidator < ActiveModel::EachValidator
 
  def validate_each(record, attribute, value)

    return if value.blank?
    regexp = Regexp.new('^(?:[^@.<>\)\(\[\]]{1}[^@<>\)\(\[\]]+[^@.<>\)\(\[\]]{1})@' + 
    "(?:[a-zA-Z]{1}[-a-zA-Z0-9]+\.)+[a-zA-Z]{1}[-a-zA-Z0-9]+$")
    unless regexp.match(value)
      record.errors[attribute] << I18n.t(:invalid_email_address, :scope => [:errors, :messages])
    end
  end
    
end
