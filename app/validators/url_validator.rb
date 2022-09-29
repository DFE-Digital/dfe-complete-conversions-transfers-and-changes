class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    uri = URI.parse(value)

    record.errors.add(attribute, :https_only) unless uri.scheme == "https"
    record.errors.add(attribute, :host_not_allowed) unless options[:hostnames].any? { |hostname| uri.hostname&.include?(hostname) }
  rescue URI::InvalidURIError
    record.errors.add(attribute, :invalid)
  end
end
