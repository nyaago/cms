# = DomainValidator
# Domain名のvalidator
# ラテン文字・数字・“-”（先頭はラテン文字または数字）をdotで区切ったもののみ有効
class DomainValidator < ActiveModel::EachValidator
 
  def validate_each(record, attribute, value)

    return if value.blank?
    regexp = Regexp.new("^(?:[a-zA-Z]{1}[-a-zA-Z0-9]+\.)+[a-zA-Z]{1}[-a-zA-Z0-9]+$")
    unless regexp.match(value)
      record.errors[attribute] << I18n.t(:invalid_domain, :scope => [:errors, :messages])
    end
  end
    
end
