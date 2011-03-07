# = HttpUrlValidator
# Http の url でのvalidator
# http:// または　https:// ではじめるかのチェックのみ
class HttpUrlValidator < ActiveModel::EachValidator
 
  def validate_each(record, attribute, value)

    return if value.blank?
    regexp = Regexp.new("^http(?:s{0,1})\://")
    unless regexp.match(value)
      record.errors[attribute] << I18n.t(:invalid_http_url, :scope => [:errors, :messages])
    end
  end
    
end
