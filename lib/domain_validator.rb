# = DomainValidator
# Domain名のvalidator
class DomainValidator < ActiveModel::EachValidator
 
  def validate_each(record, attribute, value)

    regexp = Regexp.new("^(?:[a-zA-Z]{1}[-a-zA-Z0-9]+\.)+[a-zA-Z]{1}[-a-zA-Z0-9]+$")
    unless regexp.match(value)
      record.errors[attribute] << I18n.t(:invalid_domain, :scope => [:errors, :messages])
    end
  end
    
end
