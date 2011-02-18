# = Validator::Email
# Email アドレスのvalidator
class EmailValidator < ActiveModel::EachValidator
 
  def validate_each(record, attribute, value)

    regexp = Regexp.new('^(?:[^@.<>\)\(\[\]]{1}[^@<>\)\(\[\]]+[^@.<>\)\(\[\]]{1})@' + 
    "(?:[a-zA-Z]{1}[-a-zA-Z0-9]+\.)+[a-zA-Z]{1}[-a-zA-Z0-9]+$")
    unless regexp.match(value)
      record.errors[attribute] << I18n.t(:invalid_email_address, :scope => [:errors, :messages])
    end
  end
    
end
